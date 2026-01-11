# Football Analytics Dashboard

A professional-grade data engineering and analytics pipeline for European football leagues. This project automates the collection of match data, stores it in a structured SQLite database, and visualizes insights via an interactive "Dual-Mode" dashboard.

## Features

* **Automated Scraper:** Fetches the latest match data for major European leagues (Premier League, Serie A, La Liga, Bundesliga, Ligue 1) directly from football-data.co.uk.
* **Robust ETL Pipeline:** A custom Data Loader cleans raw CSVs and ingests them into a normalized SQLite database.
* **Dual-Mode Dashboard:**
    * **League Mode:** High-level overview of season trends, attack/defense quality scatter plots, and discipline tables.
    * **Match Mode:** Deep-dive Head-to-Head analysis for upcoming games (Form, Corners, Shots on Target, Defensive Vulnerabilities).
* **Multi-League Support:** Easily switch analysis between different leagues (e.g., Premier League vs. Serie A).

## Project Structure

football-analytics-dashboard/
│
├── data/
│   ├── raw/                  # Storage for scraped CSV files
│   └── football_2526.db      # The main SQLite database (Generated)
│
├── notebooks/
│   └── Full_Dashboard.ipynb  # Interactive Analysis Tool (Jupyter)
│
├── src/
│   ├── database/
│   │   ├── data_loader.py    # ETL Script: CSV -> SQLite
│   │   └── queries/          # Saved SQL analysis scripts
│   │
│   └── scraper/
│       └── football_data_scraper.py  # Data Collection Script
│
└── requirements.txt          # Python dependencies

## Installation

1. Clone the repository:
   git clone https://github.com/krzysztofzbyrowski/football-analytics-dashboard.git
   cd football-analytics-dashboard

2. Install dependencies:
   pip install -r requirements.txt

## How to Run

1. Scrape the Data
   Download the latest match stats for the current season (2025/2026).
   python src/scraper/football_data_scraper.py

2. Build the Database
   Process the raw CSVs and update the SQLite database.
   python src/database/data_loader.py

3. Launch the Dashboard
   Open the Jupyter Notebook to explore the data.
   jupyter notebook notebooks/Full_Dashboard.ipynb

   Note: In the notebook, you can toggle ANALYSIS_MODE between "MATCH" and "LEAGUE".

## Technologies Used

* Python: Core logic and scripting.
* SQLite: Relational database for structured data storage.
* Pandas: Data manipulation and cleaning.
* Plotly: Interactive, publication-quality visualizations.
* Requests: HTTP library for robust web scraping.