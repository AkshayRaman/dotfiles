import requests
import sys
import json
import os
import time

from bs4 import BeautifulSoup

HEADERS = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:56.0) Gecko/20100101 Firefox/56.0',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Accept-Language': 'en-US,en;q=0.5',
    'Accept-Encoding': 'gzip, deflate',
    'DNT': '1',
    'Connection': 'keep-alive',
    'Upgrade-Insecure-Requests': '1'
}

CACHE_FILE = "cached_urls.json"

def load_cache():
    ''' '''
    _cache = {}
    if os.path.exists(CACHE_FILE):
        _cache = json.loads(open(CACHE_FILE).read())
        print("Cached results: %s" % len(_cache))
    else:
        print("%s not found!" % CACHE_FILE)
    return _cache

def google(q, _cache={}):
    ''' '''
    raw_q = q.lower()
    if raw_q in _cache:
        output = _cache[raw_q]
        print("Cached result: %s" % output)
        return output

    s = requests.Session()
    q = '+'.join(q.split())
    url = 'https://www.google.com/search?q=' + q + '&ie=utf-8&oe=utf-8'
    r = s.get(url, headers=HEADERS)

    soup = BeautifulSoup(r.text, "html.parser")
    output = []
    for searchWrapper in soup.find_all('h3', {'class':'r'}):
        url = searchWrapper.find('a')["href"]
        text = searchWrapper.find('a').text.strip()
        output.append(url)

    _cache[raw_q] = output
    with open(CACHE_FILE, 'w') as fp:
        json.dump(_cache, fp)

    return output


def visit_page(url, search_term):
    ''' '''
    logs_dir = "docs"
    if not os.path.exists(logs_dir):
        os.mkdir(logs_dir)
    try:
        header_line = "Search: %s <a href='%s'>%s</a><br><br>" %(search_term, url, url)
        s = requests.Session()
        r = s.get(url, headers=HEADERS)
        ts = str(int(time.time()))
        search_term = search_term.replace(" ", "_")
        file_name = "%s_%s.html" %(search_term, ts)
        file_name = os.path.join(logs_dir, file_name)
        with open(file_name, 'w') as fp:
            fp.write(header_line)
            fp.write(r.content)

    except:
        print("Error in visiting %s" % url)

if __name__ == "__main__":
    if len(sys.argv) >= 2:
        _cache = load_cache()
        search_term = sys.argv[1]
        results = google(search_term, _cache)

        for url in results:
            visit_page(url, search_term)
