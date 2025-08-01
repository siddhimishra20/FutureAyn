# TechRadar – Backend Documentation 

## Overview

This project is an AI-powered Market Intelligence Dashboard designed to scrape, process,
summarize, and visualize real-time technology news relevant to the oil & gas sector, with a
focus on ADNOC’s innovation use cases. It uses RSS feeds, vector databases, LLMs, and
automated workflows built using n8n.

### 1. System Requirements

```
● Node.js: >=18.x
```
```
● n8n: >=1.94.0 (self-hosted recommended)
```
```
● Python3 environment (for scraper script)
```
```
● Docker
```
```
● A running Supabase project
```
## Data Pipeline Flow

### 1. News Scraper Execution

```
● Triggered every hour via the n8n Schedule Trigger
● Runs News_Scraper_Demo_Location.py inside the container
● Outputs JSON of articles with metadata (url, title, date, summary, impact, trust score,
location,lat/lng)
```
### 2. Data Processing in n8n

```
● Parses Python output using Code node
● Cleans and combines fields into a single string for vector storage
● Embeds text using Ollama
● Stores embeddings and metadata into Supabase vector store
```
### 3. AI Agent for User Queries

```
● ChatTrigger node listens for webhook messages via Ngrok
● AI agent uses:
```

```
○ Memory buffer for session context
○ OpenRouter for generating human-like responses
● Agent returns a formatted summary with:
○ Title, date, source, trust score
○ Clear concise summaries per article
```
## Required Packages & Tools

### 1. Python Environment (for the scraper)

Ensure this script exists and is accessible:
/data/shared/News_Scraper_Demo_Location.py

Install dependencies:

pip install feedparser requests beautifulsoup4 fake_useragent

### 2. Supabase

```
❖ Requires a Vector Table to store vector data (N8N)
```
```
Includes fields like:
```
```
● ID
● Content
● Metadata
● embedding (768-dimensional vector)
```
```
The embedding is generated using nomic-embed-text:latest ,
snowflake-arctic-embed:22m
```
```
❖ Store your credentials in n8n’s credential manager with:
● Project URL
● Public API Key
```
### 3. OpenRouter

Create a credential in n8n with your OpenRouter API key:

```
● Model used: deepseek/deepseek-chat-v3-0324:free
```

### 4. Ollama

Ensure embedding models like nomic-embed-text or snowflake-arctic-embed are
available. Set Ollama base URL and token in credentials.

## Running the Application

### n8n Automation Tool

```
● Installation
```
```
○ Self hosted via Docker: n8nio/n8n:latest
○ https://github.com/n8n-io/self-hosted-ai-starter-kit?tab=rea
dme-ov-file
```
We use a custom Dockerfile extending the AI Starter Kit image to include required Python and
other dependencies.

## Ngrok Tunneling

We used Ngrok to expose our local n8n instance:

**1. Install Ngrok
2. Add to ngrok.yml:**

```
authtoken: YOUR_NGROK_AUTH_TOKEN
```
```
tunnels:
```
```
n8n:
```
```
proto: http
```
```
addr: 5678
```
```
inspect: false
```
## Import Your Workflow

1. Open [http://localhost:5678](http://localhost:5678) (or ngrok URL exposing localhost 5678
    if connecting to chatbot via webhooks)
2. Click **Import Workflow**


3. Upload workflows/Final_N8N.json
4. Ensure your credentials for:
    ○ Supabase
    ○ OpenRouter
    ○ Ollama
       ...are defined in the **Credentials** tab.
5. Click **Activate Workflow**

## Frontend Integration

The frontend is built on Lovable and acts as the face of the project, allowing users to query
global tech news and receive summarised, trusted, and high-impact insights in a visually
appealing format. It connects in real time to:

```
● A chatbot agent (deployed in n8n , accessed via Production URL )
```
```
● A vector database of enriched news articles stored in Supabase
```
### 1. Chatbot Integration via Ngrok

```
● The frontend sends user queries to an n8n webhook exposed via Ngrok.
```
Endpoint:
POST https://<ngrok-id>.ngrok.io/webhook/ai-agent

Payload example:
{

"chatInput": "What's the latest in AI and Oil & Gas?"

}

```
● The response includes:
○ Relevant article summaries
○ Titles, sources, dates
○ Structured text suitable for chat display
```
### 2. Supabase Integration for News Metadata

```
● On initial page load or in sidebar/highlights view, the frontend can pull recent articles
directly from Supabase, showcasing real-time news along with their impact on ADNOC.
```

