import requests
from bs4 import BeautifulSoup

# Get URL input
url = str(input("URL to Scrape: "))
try:
    r = requests.get(url)
except requests.exceptions.MissingSchema:
    print("URL not found.")
    exit()


soup = BeautifulSoup(r.content, 'html.parser')
content = soup.find_all('p')


