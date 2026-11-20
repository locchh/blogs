#!/usr/bin/env bash
# Render every mermaid block of a post in headless Chrome (the site build does not check mermaid).
# usage: scripts/mermaid-check.sh src/content/blog/<post>.md [port]   -> "0:OK | 1:ERR ..." per block
set -u
f=$1; port=${2:-8765}; repo=$(git rev-parse --show-toplevel)
d=$(mktemp -d); link=$repo/.mmcheck$port
python3 - "$f" "$d" <<'PY'
import re,json,sys
t=open(sys.argv[1]).read(); b=re.findall(r'```mermaid\n(.*?)```',t,re.S)
json.dump(b,open(sys.argv[2]+'/blocks.json','w')); print(len(b),'blocks')
PY
cat > "$d/index.html" <<'H'
<html><body><div id="log">pending</div><script type="module">
import mermaid from '/node_modules/mermaid/dist/mermaid.esm.min.mjs';
mermaid.initialize({startOnLoad:false});
const blocks=await (await fetch('blocks.json')).json(); const res=[];
for (let i=0;i<blocks.length;i++){ try{ await mermaid.parse(blocks[i]); await mermaid.render('d'+i,blocks[i]); res.push(i+':OK'); }catch(e){ res.push(i+':ERR '+String(e.message||e).slice(0,200).replace(/</g,'(')); } }
document.getElementById('log').textContent=res.join(' | ');
</script></body></html>
H
ln -sfn "$d" "$link"
(cd "$repo" && python3 -m http.server "$port" --bind 127.0.0.1 >/dev/null 2>&1 &); sleep 1
google-chrome --headless=new --disable-gpu --no-sandbox --virtual-time-budget=40000 --dump-dom "http://127.0.0.1:$port/.mmcheck$port/index.html" 2>/dev/null | grep -o '<div id="log">[^<]*</div>'
rm -f "$link"; pkill -f "[h]ttp.server $port"; rm -rf "$d"; true
