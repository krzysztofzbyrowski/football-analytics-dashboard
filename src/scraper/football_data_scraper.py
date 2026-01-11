import os
import logging
import requests
from pathlib import Path
from typing import List, Optional

# --- CONFIGURATION ---
BASE_URL = "https://www.football-data.co.uk/mmz4281/"
SAVE_DIR = Path("data/raw")

# Target Data
SEASONS = ['2526']  # Add previous seasons if needed: ['2425', '2324']
LEAGUES = {
    'E0': 'Premier_League',
    'E1': 'Championship',
    'D1': 'Bundesliga',
    'I1': 'Serie_A',
    'SP1': 'La_Liga',
    'F1': 'Ligue_1'
}

# Request Headers (Mimic a browser to avoid blocking)
HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
}

# --- LOGGING SETUP ---
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'
)
logger = logging.getLogger(__name__)

class FootballDataScraper:
    def __init__(self, save_dir: Path):
        self.save_dir = save_dir
        self._setup_directories()

    def _setup_directories(self):
        """Ensures the data directory exists."""
        if not self.save_dir.exists():
            self.save_dir.mkdir(parents=True, exist_ok=True)
            logger.info(f"📁 Created directory: {self.save_dir}")

    def download_file(self, url: str, save_path: Path) -> bool:
        """
        Downloads a single file from the URL.
        Returns True if successful, False otherwise.
        """
        try:
            logger.info(f"⬇️ Downloading: {url}")
            response = requests.get(url, headers=HEADERS, timeout=10)
            
            if response.status_code == 200:
                with open(save_path, 'wb') as f:
                    f.write(response.content)
                logger.info(f"✅ Saved to: {save_path.name}")
                return True
            else:
                logger.warning(f"❌ File not found (Status {response.status_code}): {url}")
                return False

        except requests.exceptions.RequestException as e:
            logger.error(f"⚠️ Network error downloading {url}: {e}")
            return False

    def run(self):
        """Main execution loop."""
        success_count = 0
        total_count = 0

        logger.info(f"🚀 Starting scraper for {len(SEASONS)} seasons and {len(LEAGUES)} leagues...")

        for season in SEASONS:
            for league_code, league_name in LEAGUES.items():
                total_count += 1
                
                # Construct URL
                # Pattern: https://www.football-data.co.uk/mmz4281/2526/E0.csv
                url = f"{BASE_URL}{season}/{league_code}.csv"
                
                # Construct Save Path (e.g., data/raw/Premier_League_2526.csv)
                filename = f"{league_name}_{season}.csv"
                save_path = self.save_dir / filename
                
                if self.download_file(url, save_path):
                    success_count += 1

        logger.info("=" * 40)
        logger.info(f"🏁 Scraping Completed. Success: {success_count}/{total_count}")
        logger.info("=" * 40)

if __name__ == "__main__":
    # Initialize and run
    scraper = FootballDataScraper(save_dir=SAVE_DIR)
    scraper.run()