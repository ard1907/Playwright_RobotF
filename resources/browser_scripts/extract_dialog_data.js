/**
 * resources/browser_scripts/extract_dialog_data.js
 * 
 * Script that encapsulates complex DOM-Traversal to extract
 * data fields and sender organization information from the register result dialog.
 * It expects to be called via Playwright's `evaluate` with an argument `args` that
 * defines what to extract ('sender' or 'fields').
 */

(dialog, arg) => {
    // -------------------------------------------------------------------------
    // Sender Extraction
    // -------------------------------------------------------------------------
    if (arg === 'sender') {
        const h1 = dialog.querySelector('h1');
        if (!h1) return '';
        
        const SKIP = ['BUTTON','INPUT','SELECT','SCRIPT','STYLE','H1','H2','H3','H4','H5','H6'];
        const w = document.createTreeWalker(dialog, NodeFilter.SHOW_TEXT, null);
        let past = false;
        
        while (w.nextNode()) {
            const n = w.currentNode;
            if (!past) {
                if (h1.contains(n)) {
                    past = true;
                }
                continue;
            }
            
            const t = (n.textContent || '').trim();
            if (t.length < 10) continue;
            
            let el = n.parentElement;
            let bad = false;
            while (el && el !== dialog) {
                if (SKIP.includes(el.tagName)) {
                    bad = true;
                    break;
                }
                el = el.parentElement;
            }
            if (!bad) return t;
        }
        return '';
    }

    // -------------------------------------------------------------------------
    // Data Fields Extraction
    // -------------------------------------------------------------------------
    if (arg === 'fields') {
        const f = [];
        const clean = t => (t || '').trim().replace(/:$/, '');
        const INLINE = ['SPAN','P','STRONG','EM','B','I','LABEL'];
        const INL_OR_BLOCK = ['SPAN','P','STRONG','EM','B','I','LABEL','DIV','LI'];
        
        const addIfValid = (k, v) => {
            if (k && k.length >= 2 && k.length < 100 && !k.match(/^\d+$/) && v.length < 300) {
                f.push({key: k, value: v});
            }
        };
        
        // 1. Definition List (<dt> / <dd>)
        const dts = [...dialog.querySelectorAll('dt')];
        if (dts.length > 0) {
            dts.forEach(dt => {
                const dd = dt.nextElementSibling;
                if (dd && dd.tagName === 'DD') {
                    const k = clean(dt.textContent);
                    const v = clean(dd.textContent);
                    addIfValid(k, v);
                }
            });
            if (f.length > 0) return f;
        }
        
        // 2. Table Rows (<tr> with <td> cells)
        const rows = [...dialog.querySelectorAll('tr')];
        rows.forEach(tr => {
            const cells = [...tr.querySelectorAll('td')];
            if (cells.length >= 2) {
                const k = clean(cells[0].textContent);
                const v = clean(cells[1].textContent);
                addIfValid(k, v);
            }
        });
        if (f.length > 0) return f;
        
        // 3. Fallback sibling blocks
        const seen = new Set();
        [...dialog.querySelectorAll('*')].forEach(el => {
            const ch = [...el.children];
            if (ch.length === 2 && INL_OR_BLOCK.includes(ch[0].tagName) && INL_OR_BLOCK.includes(ch[1].tagName) && ch[0].children.length === 0 && ch[1].children.length === 0) {
                const k = clean(ch[0].textContent);
                const v = clean(ch[1].textContent);
                const sig = k + '|' + v;
                if (!seen.has(sig)) {
                    seen.add(sig);
                    addIfValid(k, v);
                }
            }
        });
        if (f.length > 0) return f;
        
        // 4. Tree Walker Fallback
        const SKIP_TAGS = ['BUTTON','INPUT','SELECT','SCRIPT','STYLE','H1','H2','H3','H4','H5','H6'];
        const walker = document.createTreeWalker(dialog, NodeFilter.SHOW_TEXT, null);
        const texts = [];
        
        while (walker.nextNode()) {
            const n = walker.currentNode;
            let el = n.parentElement;
            let bad = false;
            while (el && el !== dialog) {
                if (SKIP_TAGS.includes(el.tagName)) {
                    bad = true;
                    break;
                }
                el = el.parentElement;
            }
            if (bad) continue;
            
            const t = (n.textContent || '').trim();
            if (t.length >= 2 && t.length < 100) {
                texts.push(t);
            }
        }
        
        const SEC_RE = /^[A-ZÄÖÜ][a-zäöüß ]+[a-zäöüß]$/;
        const cleaned = texts.filter(t => !SEC_RE.test(t) || t.split(' ').length <= 2);
        
        for (let i = 0; i + 1 < cleaned.length; i += 2) {
            const k = clean(cleaned[i]);
            const v = clean(cleaned[i+1]);
            addIfValid(k, v);
        }
        
        return f;
    }
    
    return null;
}