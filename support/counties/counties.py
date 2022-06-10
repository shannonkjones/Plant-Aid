import csv
import requests
from bs4 import BeautifulSoup

# Downloads the list of all US counties and equivalents from Wikipedia and exports it as a CSV of county/state pairs

COUNTY_URL = 'https://en.wikipedia.org/wiki/List_of_United_States_counties_and_county_equivalents'

resp = requests.get(COUNTY_URL)
soup = BeautifulSoup(resp.text, 'html.parser')

county_table = soup.find('table')
county_rows = county_table.find_all('tr')[1:]

counties = []
current_state = None
for row in county_rows:
    cells = row.find_all('td')
    if len(cells) == 4:
        current_state = cells[1].find_all('a')[-1].string
    county = cells[0].a.string
    counties.append({'county': county, 'state': current_state})

with open('counties.csv', 'w') as csvfile:
    csv_writer = csv.DictWriter(csvfile, fieldnames=['county', 'state'])
    csv_writer.writeheader()
    for county in counties:
        csv_writer.writerow(county)
