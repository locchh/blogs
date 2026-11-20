#!/usr/bin/env python3
"""Check that a rewritten post kept the original's links, quotes, numbers, code and front matter.
usage: scripts/survive-check.py <git-rev> src/content/blog/<post>.md [--body-cuts-ok]
With --body-cuts-ok, missing quotes and numbers are listed but do not fail (for a rewrite that cuts parts)."""
import re,sys,subprocess
rev,path=sys.argv[1],sys.argv[2]; soft='--body-cuts-ok' in sys.argv
o=subprocess.run(['git','show',f'{rev}:{path}'],capture_output=True,text=True,check=True).stdout
n=open(path).read(); bad=0
def chk(name,items,hard=True):
    global bad
    miss=[i for i in items if i not in n]
    print(f'{name}: {len(items)} checked, {len(miss)} missing'+('' if hard else ' (allowed)'))
    for m in miss[:12]: print('   MISSING:',m[:140].replace('\n',' / '))
    if hard: bad+=len(miss)
chk('frontmatter',[o.split('---',2)[1]])
chk('urls',sorted(set(re.findall(r'\]\(([^)\s]+)\)',o))))
chk('code blocks',[b for b in re.findall(r'```.*?```',o,re.S) if not b.startswith('```mermaid')])
chk('quotes',sorted(set(re.findall(r'"([^"\n]{25,})"',o))),not soft)
chk('numbers',sorted(set(re.findall(r'(?<![\w.])\d[\d,.]*\d%?|\d+%',re.sub(r'```.*?```','',o,flags=re.S)))),not soft)
print('words',len(o.split()),'->',len(n.split()),'| mermaid',o.count('```mermaid'),'->',n.count('```mermaid'))
sys.exit(1 if bad else 0)
