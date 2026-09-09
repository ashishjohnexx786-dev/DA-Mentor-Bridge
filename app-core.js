const KEY='daMentorBridge.v2',SCHEMA=3;
const R=window.C2B_REGISTRY;
const THEMES=['amoled','midnight','slate','forest','ocean','ember','graphite'];
const THEME_NAMES={amoled:'AMOLED Black',midnight:'Midnight',slate:'Slate',forest:'Forest',ocean:'Ocean',ember:'Ember',graphite:'Graphite'};
const q=x=>document.querySelector(x),qa=x=>[...document.querySelectorAll(x)];
const today=()=>new Date().toISOString().slice(0,10);
const esc=v=>String(v??'').replace(/[&<>"']/g,m=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[m]));
const dl=(name,text,type='text/plain')=>{const a=document.createElement('a');a.href=URL.createObjectURL(new Blob([text],{type}));a.download=name;a.click();setTimeout(()=>URL.revokeObjectURL(a.href),500)};
const csv=rows=>rows.map(r=>r.map(v=>`"${String(v??'').replaceAll('"','""')}"`).join(',')).join('\n');

function fresh(){
 const lessonState={},moduleArtifacts={},gates={};
 R.modules.forEach(m=>{
   m.lessons.forEach(l=>lessonState[l.id]={attempt:false,review:false,mastered:false,skipped:false,legacyComplete:false});
   moduleArtifacts[m.id]={};m.moduleArtifacts.forEach(a=>moduleArtifacts[m.id][a.id]=false);
   gates[m.id]={A:{attempt:false,review:false,result:'',repairDone:false},B:{assigned:false,attempt:false,review:false,result:'',repairDone:false},C:{assigned:false,attempt:false,review:false,result:'',repairDone:false}};
 });
 return {schemaVersion:SCHEMA,phase:'B01',lessonState,moduleArtifacts,gates,readiness:{},theme:'midnight',name:'',
  dailyTarget:2,backupEvery:7,lastBackup:'',focusLog:{},focusSessions:[],tasks:[],notes:{},errors:[],evidence:[],migration:{legacyDetected:false,legacyCount:0}};
}
function migrate(raw){
 const n=fresh(); if(!raw||typeof raw!=='object')return n;
 ['theme','name','dailyTarget','backupEvery','lastBackup','focusLog','focusSessions','tasks','notes','errors','evidence','phase'].forEach(k=>{if(raw[k]!=null)n[k]=raw[k]});
 if(raw.schemaVersion===SCHEMA){
   for(const id of Object.keys(n.lessonState))n.lessonState[id]=Object.assign(n.lessonState[id],raw.lessonState?.[id]||{});
   for(const m of R.modules){
     n.moduleArtifacts[m.id]=Object.assign(n.moduleArtifacts[m.id],raw.moduleArtifacts?.[m.id]||{});
     for(const g of ['A','B','C'])n.gates[m.id][g]=Object.assign(n.gates[m.id][g],raw.gates?.[m.id]?.[g]||{});
   }
   n.readiness=Object.assign({},raw.readiness||{});n.migration=Object.assign(n.migration,raw.migration||{});
   return n;
 }
 // Preserve legacy v1/v2 evidence, but never silently promote old checkmarks to new mastery.
 let count=0;
 if(raw.done&&typeof raw.done==='object'){
   R.modules.forEach(m=>m.lessons.forEach((l,i)=>{if(raw.done[`${m.id}:${i}`]){n.lessonState[l.id].legacyComplete=true;count++}}));
 }
 if(raw.skippedLessons)R.modules.forEach(m=>m.lessons.forEach((l,i)=>{if(raw.skippedLessons[`${m.id}:${i}`])n.lessonState[l.id].skipped=true}));
 if(raw.capstone)n.moduleArtifacts.B06.capstoneLegacy=true;
 if(raw.gate)n.gates.B06.A.legacyPassed=true;
 n.migration={legacyDetected:count>0||!!raw.capstone||!!raw.gate,legacyCount:count};
 return n;
}
let s;try{s=migrate(JSON.parse(localStorage.getItem(KEY)||'null'))}catch{s=fresh()}
const persist=()=>localStorage.setItem(KEY,JSON.stringify(s));
const save=()=>{persist();render()};
const moduleById=id=>R.modules.find(m=>m.id===id);
const lessonState=id=>s.lessonState[id]||(s.lessonState[id]={attempt:false,review:false,mastered:false,skipped:false,legacyComplete:false});
const masteredCount=()=>R.modules.flatMap(m=>m.lessons).filter(l=>lessonState(l.id).mastered).length;
const moduleLessonDone=m=>m.lessons.filter(l=>lessonState(l.id).mastered).length;
const artifactsDone=m=>m.moduleArtifacts.every(a=>!!s.moduleArtifacts[m.id]?.[a.id]);
const passedGate=m=>['A','B','C'].some(g=>['PASS','PASS_AFTER_REPAIR'].includes(s.gates[m.id]?.[g]?.result));
const moduleComplete=m=>moduleLessonDone(m)===m.lessons.length&&artifactsDone(m)&&passedGate(m);
function moduleUnlocked(m){const i=R.modules.findIndex(x=>x.id===m.id);return i===0||moduleComplete(R.modules[i-1])}
const gateAUnlocked=m=>moduleUnlocked(m)&&moduleLessonDone(m)===m.lessons.length&&artifactsDone(m);
const assignedGate=(m,g)=>g==='A'?gateAUnlocked(m):!!s.gates[m.id][g]?.assigned;
function readinessPass(){return Object.entries(R.c3Entry.floors).every(([k,v])=>(+s.readiness[k]||0)>=v)}
const c3Ready=()=>moduleComplete(moduleById('B06'))&&readinessPass();
const packageMode=()=>location.pathname.includes('/MENTOR_APP/')||location.protocol==='file:';
const artifactHref=(mid,path)=>`../COURSE_MODULES/${mid}/${path}`;
function toast(t){const x=document.createElement('div');x.className='copyToast';x.textContent=t;document.body.appendChild(x);setTimeout(()=>x.remove(),1400)}
async function copyPath(mid,path){const full=`COURSE_MODULES/${mid}/${path}`;try{await navigator.clipboard.writeText(full);toast('Path copied')}catch{prompt('Copy this course-package path:',full)}}
function fileButton(mid,path,label){
 if(packageMode())return `<a class="btn secondary" href="${artifactHref(mid,path)}" target="_blank" rel="noopener">${esc(label)}</a>`;
 return `<button class="btn secondary" data-copy-mid="${mid}" data-copy-path="${esc(path)}">${esc(label)} • copy path</button>`;
}
function bindCopy(){qa('[data-copy-path]').forEach(b=>b.onclick=()=>copyPath(b.dataset.copyMid,b.dataset.copyPath))}
function currentModule(){let m=moduleById(s.phase);if(!m||!moduleUnlocked(m)){m=R.modules.find(moduleUnlocked)||R.modules[0];s.phase=m.id;persist()}return m}
function nextLesson(m){return m.lessons.find(l=>!lessonState(l.id).mastered&&!lessonState(l.id).skipped)||m.lessons.find(l=>!lessonState(l.id).mastered)||null}
function statusText(st){return st.mastered?'MASTERED':st.review?'REVIEW OPENED':st.attempt?'ATTEMPT SAVED':st.legacyComplete?'LEGACY • VERIFY':st.skipped?'SKIPPED':'NOT STARTED'}
function routeSources(l){
 const items=l.sources||[];
 if(!items.length)return `<div class="sourceLine muted">Course-built route. No external media required.</div>`;
 return items.map(x=>`<div class="sourceLine"><span class="pill">${x.kind==='video'?'Optional visual':'Reference'}</span> <a target="_blank" rel="noopener" href="${esc(x.url)}">${esc(x.title)}</a>${x.scope?` <span class="muted">• ${esc(x.scope)}</span>`:''}</div>`).join('');
}
function moduleStatus(m){return moduleComplete(m)?'PASSED':!moduleUnlocked(m)?'LOCKED':gateAUnlocked(m)?'GATE READY':'ACTIVE'}
