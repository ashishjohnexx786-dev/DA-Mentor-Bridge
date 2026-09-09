
function renderLesson(m,l){
 const st=lessonState(l.id),locked=!moduleUnlocked(m);
 let actions=fileButton(m.id,l.book,'Open lesson book')+fileButton(m.id,l.practice,'Open practice');
 if(!st.attempt)actions+=`<button class="btn primary" data-lesson-action="attempt" data-lid="${l.id}" ${locked?'disabled':''}>Save genuine attempt</button>`;
 else{
   actions+=fileButton(m.id,l.review,'Open protected review');
   if(!st.review)actions+=`<button class="btn primary" data-lesson-action="review" data-lid="${l.id}">I opened the review</button>`;
   else if(!st.mastered)actions+=`<button class="btn primary" data-lesson-action="master" data-lid="${l.id}">Changed transfer passed • Master</button>`;
 }
 if(!st.mastered)actions+=`<button class="btn" data-lesson-action="skip" data-lid="${l.id}">${st.skipped?'Resume lesson':'Skip for now'}</button>`;
 if(st.legacyComplete&&!st.mastered)actions+=`<button class="btn secondary" data-lesson-action="verifyLegacy" data-lid="${l.id}">Verify legacy evidence</button>`;
 return `<div class="lessonCard ${locked?'locked':''}" data-lesson-row="${l.id}">
  <div class="lessonHead"><div><div class="lessonTitle">${l.id} • ${esc(l.title)}</div><div class="muted tiny">READ → ATTEMPT → REVIEW → CHANGED TRANSFER → MASTER</div></div>
  <div class="statusPills"><span class="pill ${st.mastered?'good':st.review||st.attempt||st.legacyComplete?'warnP':''}">${statusText(st)}</span></div></div>
  <div class="lessonActions">${actions}</div>
  <div class="pathBox">Book: COURSE_MODULES/${m.id}/${esc(l.book)}<br>Practice: COURSE_MODULES/${m.id}/${esc(l.practice)}</div>
  <div class="sourceList">${routeSources(l)}</div></div>`;
}
function renderModuleRoutes(m){
 const xs=[fileButton(m.id,m.start,'Start Here'),fileButton(m.id,m.lessons[0].book,'Lesson Book'),fileButton(m.id,m.lessons[0].practice,'Practice')];
 m.setup.forEach((p,i)=>xs.push(fileButton(m.id,p,i===0?'Setup / Data':`Setup ${i+1}`)));
 return xs.join('');
}
function renderArtifacts(m){
 q('#moduleArtifacts').innerHTML=m.moduleArtifacts.map(a=>{
   const done=!!s.moduleArtifacts[m.id]?.[a.id],available=moduleLessonDone(m)===m.lessons.length;
   return `<div class="artifactRow"><div class="row space"><div><b>${esc(a.label)}</b><div class="pathBox">COURSE_MODULES/${m.id}/${esc(a.path)}</div></div><span class="pill ${done?'good':''}">${done?'COMPLETE':'REQUIRED'}</span></div>
   <div class="artifactActions">${fileButton(m.id,a.path,'Open artifact')}<button class="btn primary" data-artifact="${a.id}" data-mid="${m.id}" ${!available?'disabled':''}>${done?'Mark incomplete':'Mark complete'}</button></div>
   ${!available?'<div class="muted tiny">Unlocks after all module lessons are mastered.</div>':''}</div>`
 }).join('');
}
function gateVariantHtml(m,g){
 const rec=m.gates[g],gs=s.gates[m.id][g],available=assignedGate(m,g);
 if(!available)return `<div class="gateVariant locked"><h3>Gate ${g} • ${esc(rec.domain)}</h3><p class="muted">${g==='A'?'Finish all lessons + required Mini-Lab/Capstone first.':'Protected fresh full retest. Requires explicit assignment after review.'}</p></div>`;
 let a=fileButton(m.id,rec.path,`Open Gate ${g}`);
 if(rec.data)a+=fileButton(m.id,rec.data,'Open Gate data');
 if(!gs.attempt)a+=`<button class="btn primary" data-gate-action="attempt" data-mid="${m.id}" data-g="${g}">Save Gate ${g} attempt</button>`;
 else{
   a+=fileButton(m.id,rec.review,`Open Review ${g}`);
   if(!gs.review)a+=`<button class="btn primary" data-gate-action="review" data-mid="${m.id}" data-g="${g}">I opened Review ${g}</button>`;
   else if(!['PASS','PASS_AFTER_REPAIR'].includes(gs.result)){
     a+=`<button class="btn primary" data-gate-action="pass" data-mid="${m.id}" data-g="${g}">PASS</button>`;
     a+=`<button class="btn danger" data-gate-action="repair" data-mid="${m.id}" data-g="${g}">Needs repair</button>`;
   }
 }
 const result=gs.result||'';
 let repair='';
 if(result==='REPAIR'){
   repair=`<div class="call warn"><b>Targeted repair only.</b><div class="gateActions">${m.remediation.map(p=>fileButton(m.id,p,'Open remediation')).join('')}
   <button class="btn" data-gate-action="repairDone" data-mid="${m.id}" data-g="${g}">Save targeted repair attempt</button>
   ${gs.repairDone?`<button class="btn primary" data-gate-action="acceptRepair" data-mid="${m.id}" data-g="${g}">Reviewer accepts changed micro-retest • Pass Gate</button>`:''}
   ${g!=='C'?`<button class="btn secondary" data-gate-action="assignNext" data-mid="${m.id}" data-g="${g}">Explicitly assign fresh full Gate ${g==='A'?'B':'C'}</button>`:''}</div>
   <p class="muted tiny">A repair result alone NEVER unlocks the next Gate.</p></div>`;
 }
 return `<div class="gateVariant"><h3>Gate ${g} • ${esc(rec.domain)} <span class="pill ${result.startsWith('PASS')?'good':result==='REPAIR'?'bad':''}">${result||'READY'}</span></h3>
 <div class="gateActions">${a}</div>${repair}</div>`;
}
function renderGates(m){
 const unlock=gateAUnlocked(m);
 q('#gatePill').textContent=passedGate(m)?'PASSED':unlock?'READY':'LOCKED';
 q('#gatePill').className='pill '+(passedGate(m)?'good':unlock?'warnP':'bad');
 q('#gateTitle').textContent=`${m.id} Mastery Gate`;
 q('#gateArea').innerHTML=['A','B','C'].map(g=>gateVariantHtml(m,g)).join('');
}
function renderReadiness(){
 const floors=R.c3Entry.floors;
 q('#readinessRows').innerHTML=Object.entries(floors).map(([k,floor])=>{
   const v=s.readiness[k],pass=(+v||0)>=floor;
   return `<div class="readinessRow"><div><b>${esc(k)}</b><div class="muted tiny">Minimum ${floor}/4</div></div><input data-ready="${esc(k)}" type="number" min="0" max="4" step="1" value="${v??''}"><span class="pill ${v==null||v===''?'':pass?'good':'bad'}">${v==null||v===''?'UNRATED':pass?'PASS':'REPAIR'}</span></div>`;
 }).join('');
 const ready=c3Ready();
 q('#c3Pill').textContent=ready?'UNLOCKED':'LOCKED';q('#c3Pill').className='pill '+(ready?'good':'bad');
 q('#readyMessage').innerHTML=ready?'<b>Course 3 entry ready.</b> B06 Final Gate passed and every documented evidence floor is met.':'<b>Course 3 remains locked.</b> Required: B06 Final Gate PASS + all readiness floors. Future C3-00 Linux/Git/testing/CLI topics are taught inside C3 and are not pre-entry requirements.';
 qa('[data-ready]').forEach(x=>x.onchange=()=>{s.readiness[x.dataset.ready]=x.value===''?'':Math.max(0,Math.min(4,+x.value));save()});
}
function render(){
 document.body.dataset.theme=s.theme||'midnight';
 const n=masteredCount(),mods=R.modules.filter(moduleComplete).length,pct=Math.round(n/R.lessonCount*100);
 q('#progressPct').textContent=pct+'%';q('#masteredCount').textContent=`${n}/${R.lessonCount}`;q('#modulesCount').textContent=`${mods}/6`;q('#courseBar').style.width=pct+'%';
 q('#greeting').textContent=s.name?`${s.name}, your Bridge path is ready.`:'Your Bridge path is ready.';
 q('#migrationBanner').hidden=!s.migration?.legacyDetected;
 if(s.migration?.legacyDetected)q('#migrationBanner').innerHTML=`<b>Legacy progress preserved safely.</b> ${s.migration.legacyCount||0} old completion marker(s) are shown as LEGACY • VERIFY, not silently promoted to the new mastery standard.`;
 const m=currentModule(),done=moduleLessonDone(m);
 q('#phaseTitle').textContent=`${m.id} — ${m.name} (${m.hours} h)`;
 q('#phaseSelect').innerHTML=R.modules.map(x=>`<option value="${x.id}" ${!moduleUnlocked(x)?'disabled':''}>${x.id} — ${x.name} • ${moduleStatus(x)}</option>`).join('');
 q('#phaseSelect').value=m.id;q('#phaseBar').style.width=(done/m.lessons.length*100)+'%';
 q('#moduleLock').innerHTML=`<b>${moduleStatus(m)}</b> • ${done}/${m.lessons.length} lessons mastered • ${m.moduleArtifacts.filter(a=>s.moduleArtifacts[m.id]?.[a.id]).length}/${m.moduleArtifacts.length} cumulative artifact(s) complete • Gate ${passedGate(m)?'passed':'pending'}`;
 q('#moduleRoutes').innerHTML=renderModuleRoutes(m);
 const nl=nextLesson(m);
 q('#nextAction').textContent=nl?`Next learner action: ${nl.id} — ${nl.title}`:!artifactsDone(m)?'Lessons mastered. Complete the required Mini-Lab / Capstone checkpoint.':!passedGate(m)?'Cumulative work complete. Attempt the protected Gate A independently.':moduleComplete(m)?'Module passed. Continue to the next unlocked module.':'Review the current evidence.';
 q('#heroLine').textContent=nl?`${m.id}: ${nl.id} — ${nl.title}`:moduleComplete(m)?`${m.id} passed.`:`${m.id}: cumulative evidence / Gate stage.`;
 q('#lessonList').innerHTML=m.lessons.map(l=>renderLesson(m,l)).join('');
 renderArtifacts(m);renderGates(m);renderReadiness();
 q('#phaseMap').innerHTML=R.modules.map(x=>`<div class="phaseNode ${moduleUnlocked(x)?'':'lockedNode'}"><b>${x.id} — ${x.name}</b><div class="muted tiny">${moduleLessonDone(x)}/${x.lessons.length} lessons • ${moduleStatus(x)}</div></div>`).join('');
 renderTasks();renderErrors();renderEvidence();renderFocus();q('#dailyNotes').value=s.notes[today()]||'';
 bindCopy();bindActions();
}
function bindActions(){
 q('#phaseSelect').onchange=e=>{const m=moduleById(e.target.value);if(moduleUnlocked(m)){s.phase=m.id;save()}};
 qa('[data-lesson-action]').forEach(b=>b.onclick=()=>{
   const st=lessonState(b.dataset.lid),act=b.dataset.lessonAction;
   if(act==='attempt'){st.attempt=true;st.skipped=false}
   if(act==='review'&&st.attempt)st.review=true;
   if(act==='master'&&st.review){st.mastered=true;st.skipped=false}
   if(act==='skip'&&!st.mastered)st.skipped=!st.skipped;
   if(act==='verifyLegacy'){st.attempt=true;st.legacyComplete=false}
   save();
 });
 qa('[data-artifact]').forEach(b=>b.onclick=()=>{const m=moduleById(b.dataset.mid);if(moduleLessonDone(m)!==m.lessons.length)return;s.moduleArtifacts[m.id][b.dataset.artifact]=!s.moduleArtifacts[m.id][b.dataset.artifact];save()});
 qa('[data-gate-action]').forEach(b=>b.onclick=()=>{
   const m=moduleById(b.dataset.mid),g=b.dataset.g,gs=s.gates[m.id][g],act=b.dataset.gateAction;if(!assignedGate(m,g))return;
   if(act==='attempt')gs.attempt=true;
   if(act==='review'&&gs.attempt)gs.review=true;
   if(act==='pass'&&gs.review)gs.result='PASS';
   if(act==='repair'&&gs.review){gs.result='REPAIR';gs.repairDone=false}
   if(act==='repairDone'&&gs.result==='REPAIR')gs.repairDone=true;
   if(act==='acceptRepair'&&gs.result==='REPAIR'&&gs.repairDone)gs.result='PASS_AFTER_REPAIR';
   if(act==='assignNext'&&gs.result==='REPAIR'&&g!=='C')s.gates[m.id][g==='A'?'B':'C'].assigned=true;
   save();
 });
}
