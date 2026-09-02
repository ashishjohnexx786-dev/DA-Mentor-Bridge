(()=>{
const RECOMMENDED=new Set(["B01-L01","B01-L03","B01-L04","B01-L06","B01-L07","B01-L12","B03-L01"]);
function install(){
 if(typeof BRIDGE_CURRICULUM!=='undefined')BRIDGE_CURRICULUM.forEach(p=>p.lessons.forEach((l,i)=>{const id=p.id+'-L'+String(i+1).padStart(2,'0');if(typeof l==='object')l.videoStatus=RECOMMENDED.has(id)?'☑ Recommended visual':'☐ Not required';}));
}
if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',install);else install();
})();
