import os
import requests
from bs4 import BeautifulSoup
import json
import time

BASE_URL = "https://www.simpsonspark.com"

def get_episode_links(season_url):
    resp = requests.get(season_url)
    resp.encoding = 'utf-8'
    soup = BeautifulSoup(resp.text, 'html.parser')
    centre = soup.find(id="centre")
    links = []
    for h2 in centre.find_all("h2"):
        a = h2.find("a", href=True)
        if not a or "/episodes/" not in a["href"]:
            continue
        title = a.get_text(strip=True)
        href  = a["href"]
        url = href if href.startswith("http") else BASE_URL + href
        links.append((title, url, h2))
    return links

def extract_description_from_listing(h2):
    texts = []
    for sib in h2.next_siblings:
        if getattr(sib, "name", None) == "h2":
            break
        if sib.name == "p":
            texts.append(sib.get_text(strip=True))
        elif isinstance(sib, str) and sib.strip():
            texts.append(sib.strip())
    return " ".join(texts).strip()

def scrape_episode_image(url):
    resp = requests.get(url)
    resp.encoding = 'utf-8'
    soup = BeautifulSoup(resp.text, 'html.parser')
    img = soup.find("img", style=lambda v: v and "float" in v)
    if not img:
        img = soup.find("img")
    return img["src"] if img and img.has_attr("src") else None

def main():
    season_num = input("Numéro de la saison à scraper (ex: 1) : ").strip()
    season_path = f"/episodes-de-la-saison-{season_num}"
    season_url = BASE_URL + season_path

    output_dir = "scrap"
    os.makedirs(output_dir, exist_ok=True)
    output_file = os.path.join(output_dir, f"saison{season_num}.json")

    episodes = get_episode_links(season_url)
    print(f"→ {len(episodes)} liens d’épisodes trouvés pour la saison {season_num}")

    result = []
    for title, url, h2 in episodes:
        print(f"   • {title}")
        desc = extract_description_from_listing(h2)
        img  = scrape_episode_image(url)
        result.append({
            "titre":       title,
            "image":       img,
            "description": desc
        })
        time.sleep(0.3)

    with open(output_file, "w", encoding="utf-8") as f:
        json.dump(result, f, ensure_ascii=False, indent=2)

    print(f"✅ {len(result)} épisodes sauvegardés dans {output_file}")

if __name__ == "__main__":
    main()

