import sqlite3
import pandas as pd
import logging
from pathlib import Path
import glob

# --- CONFIGURATION ---
DB_PATH = Path("data/football_2526.db")
RAW_DATA_DIR = Path("data/raw")

# Setup Logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

class DataLoader:
    def __init__(self, db_path: Path, raw_dir: Path):
        self.db_path = db_path
        self.raw_dir = raw_dir
        self.conn = None

    def connect(self):
        """Establishes connection to the SQLite database."""
        try:
            # Ensure the directory for the DB exists
            if not self.db_path.parent.exists():
                self.db_path.parent.mkdir(parents=True, exist_ok=True)
                
            self.conn = sqlite3.connect(self.db_path)
            logger.info(f"🔌 Connected to database: {self.db_path}")
        except sqlite3.Error as e:
            logger.error(f"❌ Database connection failed: {e}")

    def close(self):
        """Closes the database connection."""
        if self.conn:
            self.conn.close()
            logger.info("🔌 Database connection closed.")

    def clean_table_name(self, filename: str) -> str:
        """
        Derives a clean table name from the filename.
        Example: 'Premier_League_2526.csv' -> 'Premier_League'
        """
        # Remove the season suffix (e.g., _2526) and extension
        # Assumes format: LeagueName_Season.csv
        name_part = filename.rsplit('_', 1)[0] # Split at the last underscore
        return name_part.lower() # Return lowercase (e.g., 'premier_league')

    def load_files(self):
        """Scans raw folder and loads all CSVs into the DB."""
        if not self.raw_dir.exists():
            logger.error(f"❌ Raw data directory not found: {self.raw_dir}")
            return

        csv_files = list(self.raw_dir.glob("*.csv"))
        
        if not csv_files:
            logger.warning("⚠️ No CSV files found to load. Run the scraper first.")
            return

        logger.info(f"📂 Found {len(csv_files)} files to load.")

        for file_path in csv_files:
            self.process_file(file_path)

    def process_file(self, file_path: Path):
        """Reads a single CSV and writes it to the DB."""
        try:
            table_name = self.clean_table_name(file_path.name)
            
            logger.info(f"📖 Reading {file_path.name}...")
            df = pd.read_csv(file_path)
            
            # Basic cleanup: Standardize Date format if possible
            if 'Date' in df.columns:
                df['Date'] = pd.to_datetime(df['Date'], dayfirst=True, errors='coerce')

            # Write to DB
            # if_exists='append' allows adding multiple seasons to the same table
            df.to_sql(table_name, self.conn, if_exists='replace', index=False)
            
            logger.info(f"✅ Loaded {len(df)} rows into table: '{table_name}'")
            
        except Exception as e:
            logger.error(f"❌ Failed to process {file_path.name}: {e}")

if __name__ == "__main__":
    loader = DataLoader(DB_PATH, RAW_DATA_DIR)
    loader.connect()
    loader.load_files()
    loader.close()