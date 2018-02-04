def kafka_monitoring():
    import urllib2
    from bs4 import BeautifulSoup

    save_to_file = False

    def _strip(s): return s.strip()

    def fix_text(t):
        return ' '.join(map(lambda a: ' '.join(map(_strip, a.split('\\n'))), t.strip().splitlines()))

    if save_to_file:
        #_url = 'https://raw.githubusercontent.com/apache/kafka/trunk/docs/ops.html'
        _url = 'https://raw.githubusercontent.com/apache/kafka/0.11.0/docs/ops.html'
        _html = urllib2.urlopen(_url).read()
        with open('ops.html', 'w') as f:
            f.write(_html)
    else:
        with open('ops.html') as html_doc:
            html_doc = html_doc.read().decode('ascii', errors='ignore')
            s = BeautifulSoup(html_doc, 'html.parser')
            s = BeautifulSoup(repr(s.script.contents[0]).decode('ascii', errors='ignore'), 'html.parser')
            for t in s.find_all('table', {'class':'data-table'}):
                for tr in t.find_all('tr'):
                    print '\t'.join(fix_text(td.get_text()) for td in tr.find_all(['th','td']))
                print ""
