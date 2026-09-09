
function nextInstruction(){
 const m=currentModule(),l=nextLesson(m);
 if(l){const st=lessonState(l.id);if(!st.attempt)return `${l.id}: study the lesson and complete its practice. Then press “Save genuine attempt”.`;if(!st.review)return `${l.id}: your attempt is saved. Open the protected review, compare, then press “I opened the review”.`;return `${l.id}: close the review and complete a changed equivalent task. If it passes, mark mastery.`}
 if(!artifactsDone(m))return `${m.id}: all lessons are mastered. Complete the required Mini-Lab / Capstone checkpoint.`;
 if(!passedGate(m))return `${m.id}: attempt Gate A independently. Save the attempt before the protected review.`;
 const idx=R.modules.indexOf(m);if(idx<R.modules.length-1)return `Continue to ${R.modules[idx+1].id} — ${R.modules[idx+1].name}.`;
 return c3Ready()?'Course 3 is unlocked. Continue to DA Mentor Engineering.':'B06 is passed. Rate the eight C3 readiness areas from evidence; Course 3 unlocks only when every floor is met.';
}
q('#whatNowBtn').onclick=()=>alert(nextInstruction());
q('#rebuildTasksBtn').onclick=()=>{const m=currentModule(),l=nextLesson(m);s.tasks=l?[{text:`Study: ${l.id} — ${l.title}`,pom:1,done:false},{text:'Complete assigned practice and save genuine evidence',pom:2,done:false},{text:'Open protected review only after attempt; then changed transfer',pom:1,done:false}]:[{text:nextInstruction(),pom:2,done:false}];save()};
q('#addTaskBtn').onclick=()=>{const t=q('#taskText').value.trim();if(!t)return;s.tasks.push({text:t,pom:+q('#taskPom').value||1,done:false});q('#taskText').value='';save()};
function renderTasks(){q('#taskList').innerHTML=s.tasks.length?s.tasks.map((t,i)=>`<div class="task"><input type="checkbox" data-task="${i}" ${t.done?'checked':''}><span>${esc(t.text)} <small class="muted">${t.pom||1} pom</small></span><button class="btn" data-del-task="${i}">×</button></div>`).join(''):'<p class="muted">No tasks yet. Rebuild from your next action.</p>';qa('[data-task]').forEach(x=>x.onchange=()=>{s.tasks[+x.dataset.task].done=x.checked;save()});qa('[data-del-task]').forEach(x=>x.onclick=()=>{s.tasks.splice(+x.dataset.delTask,1);save()})}
q('#dailyNotes').oninput=e=>{s.notes[today()]=e.target.value;persist();q('#noteSaved').textContent='Saved'};
q('#addErrorBtn').onclick=()=>{const topic=prompt('What is weak or failing?');if(!topic)return;const repair=prompt('Targeted repair / changed retest plan?')||'Repair exact weakness → changed retest → verify';s.errors.push({topic,repair,date:today()});save()};
function renderErrors(){q('#errors').innerHTML=s.errors.length?s.errors.map((e,i)=>`<div class="error"><div><b>${esc(e.topic)}</b><div class="muted tiny">${esc(e.repair)}</div></div><button class="btn" data-del-error="${i}">×</button></div>`).join(''):'<p class="muted">No recorded weaknesses.</p>';qa('[data-del-error]').forEach(x=>x.onclick=()=>{s.errors.splice(+x.dataset.delError,1);save()})}
q('#addEvidenceBtn').onclick=()=>{const skill=q('#evSkill').value.trim(),action=q('#evAction').value.trim();if(!skill||!action)return;s.evidence.push({skill,action,date:today()});q('#evSkill').value='';q('#evAction').value='';save()};
function renderEvidence(){q('#evidenceList').innerHTML=s.evidence.length?s.evidence.map((e,i)=>`<div class="evidence"><div><b>${esc(e.skill)}</b><div class="muted tiny">${esc(e.action)} • ${esc(e.date)}</div></div><button class="btn" data-del-ev="${i}">×</button></div>`).join(''):'<p class="muted">No evidence saved yet.</p>';qa('[data-del-ev]').forEach(x=>x.onclick=()=>{s.evidence.splice(+x.dataset.delEv,1);save()})}

// Persistent manual study session.
const SESSION_KEY='daMentorBridge.studySession.v2';
function loadSS(){try{return Object.assign({active:false,startedAt:0,phase:'',sessionId:''},JSON.parse(localStorage.getItem(SESSION_KEY)||'{}'))}catch{return {active:false,startedAt:0,phase:'',sessionId:''}}}
let SS=loadSS();const elapsed=()=>SS.active?Date.now()-SS.startedAt:0;
const fmt=ms=>{const sec=Math.floor(ms/1000),h=Math.floor(sec/3600),m=Math.floor((sec%3600)/60),ss=sec%60;return h?`${String(h).padStart(2,'0')}:${String(m).padStart(2,'0')}:${String(ss).padStart(2,'0')}`:`${String(m).padStart(2,'0')}:${String(ss).padStart(2,'0')}`};
const focusToday=()=>s.focusLog[today()]||0;
function streak(){let n=0,d=new Date();while(true){const k=d.toISOString().slice(0,10);if((s.focusLog[k]||0)>0){n++;d.setDate(d.getDate()-1)}else return n}}
function drawSession(){if(q('#studySessionClock'))q('#studySessionClock').textContent=fmt(elapsed());if(q('#studySessionToggle'))q('#studySessionToggle').textContent=SS.active?'END STUDY':'START STUDY';if(q('#studySessionCancel'))q('#studySessionCancel').disabled=!SS.active;if(q('#studySessionHint'))q('#studySessionHint').textContent=SS.active?'Active session survives tab/background changes.':'Session ends only when you press END STUDY.'}
q('#studySessionToggle').onclick=()=>{
 if(!SS.active){SS={active:true,startedAt:Date.now(),phase:s.phase,sessionId:`bridge-${Date.now()}-${Math.random().toString(36).slice(2,7)}`};localStorage.setItem(SESSION_KEY,JSON.stringify(SS));drawSession();return}
 const end=Date.now(),mins=Math.max(1,Math.round((end-SS.startedAt)/60000));
 if(!s.focusSessions.some(x=>x.sessionId===SS.sessionId)){s.focusSessions.push({sessionId:SS.sessionId,date:today(),minutes:mins,phase:SS.phase,startedAt:SS.startedAt,completedAt:end});s.focusLog[today()]=(s.focusLog[today()]||0)+mins}
 SS={active:false,startedAt:0,phase:'',sessionId:''};localStorage.setItem(SESSION_KEY,JSON.stringify(SS));save();alert(`Study session saved: ${mins}m.`);
};
q('#studySessionCancel').onclick=()=>{if(SS.active&&confirm('Cancel active study session without saving?')){SS={active:false,startedAt:0,phase:'',sessionId:''};localStorage.setItem(SESSION_KEY,JSON.stringify(SS));drawSession()}};
function renderFocus(){q('#focusToday').textContent=focusToday()+'m';q('#focusPill').textContent=focusToday()+'m focus today';const target=Math.round((+s.dailyTarget||2)*60);q('#targetText').textContent=`${focusToday()}/${target}m`;q('#targetBar').style.width=Math.min(100,focusToday()/Math.max(1,target)*100)+'%';q('#targetSummary').textContent=focusToday()>=target?'Daily target reached.':`${Math.max(0,target-focusToday())} minutes remaining today.`;drawSession()}

function openModal(id){q(id).classList.add('open')}function closeModals(){qa('.modal').forEach(x=>x.classList.remove('open'))}qa('[data-close]').forEach(x=>x.onclick=closeModals);
q('#settingsBtn').onclick=()=>{q('#nameInput').value=s.name||'';q('#themeInput').innerHTML=THEMES.map(t=>`<option value="${t}">${THEME_NAMES[t]}</option>`).join('');q('#themeInput').value=s.theme;q('#dailyTarget').value=s.dailyTarget;q('#backupEvery').value=s.backupEvery;openModal('#settingsModal')};
q('#saveSettingsBtn').onclick=()=>{s.name=q('#nameInput').value.trim();s.theme=q('#themeInput').value;s.dailyTarget=+q('#dailyTarget').value||2;s.backupEvery=+q('#backupEvery').value||7;closeModals();save()};
q('#resetBtn').onclick=()=>{if(confirm('Reset all Bridge progress on this device?')){s=fresh();localStorage.removeItem(SESSION_KEY);SS=loadSS();save();closeModals()}};
q('#reportsBtn').onclick=()=>{q('#reportBody').innerHTML=`<div class="reportGrid"><div class="stat"><b>${masteredCount()}/${R.lessonCount}</b><span>Lessons mastered</span></div><div class="stat"><b>${R.modules.filter(moduleComplete).length}/6</b><span>Modules passed</span></div><div class="stat"><b>${focusToday()}m</b><span>Today</span></div><div class="stat"><b>${streak()}</b><span>Day streak</span></div></div><p><b>Course 3:</b> ${c3Ready()?'UNLOCKED':'LOCKED'}</p><p class="muted">100% lessons never bypasses the B06 Final Gate or readiness floors.</p>`;openModal('#reportsModal')};
q('#exportBtn').onclick=()=>openModal('#exportModal');
q('#exportJsonBtn').onclick=()=>{s.lastBackup=today();persist();dl('DA_Mentor_Bridge_Backup_schema3.json',JSON.stringify(s,null,2),'application/json')};
q('#exportLessonsCsvBtn').onclick=()=>{const rows=[['Module','Lesson ID','Lesson','Attempt','Review','Mastered','Skipped','Legacy']];R.modules.forEach(m=>m.lessons.forEach(l=>{const x=lessonState(l.id);rows.push([m.id,l.id,l.title,x.attempt?'Yes':'No',x.review?'Yes':'No',x.mastered?'Yes':'No',x.skipped?'Yes':'No',x.legacyComplete?'Yes':'No'])}));dl('DA_Mentor_Bridge_Lessons.csv',csv(rows),'text/csv')};
q('#exportEvidenceCsvBtn').onclick=()=>dl('DA_Mentor_Bridge_Evidence.csv',csv([['Skill','Action','Date'],...s.evidence.map(e=>[e.skill,e.action,e.date])]),'text/csv');
q('#restoreBtn').onclick=()=>q('#restoreFile').click();
q('#restoreFile').onchange=async e=>{try{s=migrate(JSON.parse(await e.target.files[0].text()));persist();render();alert('Backup restored and migrated safely.')}catch{alert('Backup could not be restored.')}};

let deferredPrompt;window.addEventListener('beforeinstallprompt',e=>{e.preventDefault();deferredPrompt=e;q('#installBtn').hidden=false});
q('#installBtn').onclick=async()=>{if(deferredPrompt){deferredPrompt.prompt();await deferredPrompt.userChoice;deferredPrompt=null;q('#installBtn').hidden=true}};
if('serviceWorker'in navigator)window.addEventListener('load',()=>navigator.serviceWorker.register('./service-worker.js').catch(()=>{}));
setInterval(drawSession,1000);document.addEventListener('visibilitychange',()=>{SS=loadSS();drawSession()});window.addEventListener('pageshow',()=>{SS=loadSS();drawSession()});
persist();render();
