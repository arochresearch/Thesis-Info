# Thesis Evaluation Pipeline & Analysis

Disclaimer: This thesis was developed as a pilot study to test an idea, not to be a fully polished or launch-ready evaluation. 

**"How General-Purpose AI Chatbots Respond to Adolescent Users in Emotionally Vulnerable Scenarios"**
Abby Rochman | M.S. Communication, Culture & Technology | Georgetown University | May 2026

## Overview
This repository contains the data collection pipeline and statistical analysis code for a mixed-methods thesis evaluating how three large language models (Claude, GPT-4o, Gemini) respond to simulated adolescent users in emotionally vulnerable scenarios. 

## Repository Contents
- `llm_judge.py` — Python pipeline for generating and scoring multi-turn conversations using a User LLM (Claude Haiku) to simulate a resistant teen across 4 scenarios × 3 models × 3 runs × 3 turns (108 conversations total)
- `analysis.R` — R script for statistical analysis including IRR (weighted kappa, Krippendorff's alpha), pairwise t-tests with Bonferroni correction, and turn-level degradation analysis
- `grading_sheet_actual.xlsx - CORRECT G.csv` — Final human and LLM scoring data across four constructs: Dependence Framing (1a), Boundary Setting (1b), Resource Diversity (2a), and Secrecy vs. Transparency (2b), each scored 0–2

## Models Evaluated
- `claude-sonnet-4-6`
- `gpt-4o`
- `gemini/gemini-2.5-flash`

## Dependencies
**Python:** `litellm`, `openai`, `anthropic`, `python-dotenv`
**R:** `irr`, `readr`, `dplyr`, `tidyr`, `rstatix`, `ggplot2`# Thesis-Info
Repository of relevant technical materials related to my Master's Thesis at Georgetown University in the CCT Program. 
