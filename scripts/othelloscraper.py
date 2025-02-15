import requests
from bs4 import BeautifulSoup

# get all pages to script
url_root = "https://www.worldothello.org/about/tournaments/world-othello-championship/woc/"
urls = [url_root + str(i) + "/crosstable/13" for i in range(1988, 2026)]

# players names shortened to
def format_player_name(playerName):
    moniker = playerName.split().reverse()
    moniker[0] = moniker[0].upper()
    moniker = ' '.join(moniker)
    return moniker[:13]

# Get URL input
url = str(input("URL to Scrape: "))
try:
    r = requests.get(url)
except requests.exceptions.MissingSchema:
    print("URL not found.")
    exit()


soup = BeautifulSoup(r.content, 'html.parser')
content = soup.find_all('p')


