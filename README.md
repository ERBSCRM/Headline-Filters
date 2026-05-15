<img src="your-logo.png" width="200" alt="Company Logo">
append company logo above

# CRM Template Repository

This repository serves as a **base template** for new Sage CRM customisation projects. It includes a recommended structure, documentation placeholders, and example content to ensure consistency across client CRM implementations.

Please make changes to this readme as you see fit 

# PLEASE DO NOT DELETE THE TEMPLATE REPO - ALWAYS ENSURE THERE IS A BACKUP OF THIS TEMPLATE STRUCTURE 

---

## 📝 About This README

This `README.md` file is a **starter guide** for any team adopting this repo template. When you create a new CRM project from this template, you should:

- Replace all placeholder sections with project-specific information
- Update or remove irrelevant examples
- Add your client's logo at the top of this file to visually brand the repo
- Include real documentation links as you develop your solution

This README ensures every new project begins with a clear, professional structure.

---


# README Writing Guidelines

This document provides guidance on how to structure and write/ edit professional `README.md` files for our Sage CRM repositories.


## Prerequisites
- You must be logged into your GitHub account
- You must have **write access** to the repository

---

## Step-by-Step Instructions

### 1. Navigate to the Repository
Go to [https://github.com](https://github.com) and open the repository you want to edit (e.g., `ERBSCRM/BekstoneCRM`).

### 2. Open the README File
On the main page of the repo, locate the file list and click on `README.md`.

### 3. Click the Edit Button
In the upper-right corner of the file view, click the **pencil icon** (labeled "Edit this file").

### 4. Make Your Edits
You are now in GitHub's built-in markdown editor. Make your changes directly in the text box.

### 5. Preview Your Changes *(Optional)*
Click the **Preview** tab to see how your markdown will look when rendered.

### 6. Write a Commit Message
At the bottom of the page:
- Add a short message in the **"Commit changes"** field (e.g., `Updated testing notes`)
- Leave the optional extended description blank or add extra context
- Choose **"Commit directly to the `main` branch"**

### 7. Commit the Changes
Click the **"Commit changes"** button to save your edits.



---

## Why a Good README Matters
A well-structured README helps:
- New developers quickly understand the purpose and structure of the repository
- Clients or reviewers identify what customisations exist and how they work
- Ensure consistent documentation across all client repositories

---

## Markdown Basics
Markdown uses symbols to control formatting. Heres what the main ones do:

### Headers
Use `#` to define section headings. The number of `#` symbols represents the heading level.
```md
# H1 - Main title
## H2 - Section
### H3 - Sub-section
```

### Bold and Italics
```md
**bold text**
*italic text*
```

### Code Blocks and Inline Code
Use backticks for code:
```md
`inline code`
```
Use triple backticks for blocks:
```md
```sql
SELECT * FROM Opportunity;
```
```

### Lists
```md
- Bullet point
1. Numbered list
```

### Tables
```md
| Column 1 | Column 2 |
|----------|-----------|
| Value A  | Value B   |
```

### Links
```md
[Link Text](https://example.com)
```

---

## Recommended README Structure
Each CRM repo README should follow a consistent format:

```md
# ClientName CRM Customisations

## Overview
Briefly describe how the client uses Sage CRM and what the repo contains.

## Key Modules in Use
- Opportunities
- Quotes
- Orders

## Customisations Summary
### Custom Pages
List and describe key ASP pages.

### Workflow Rules
Summarise key automation logic.

### SQL Scripts
What reports or triggers are managed here.

## Custom Fields
Use a table to list important fields.

## Deployment Notes
Any guidance for staging, release, rollback.
```

---

## Tips
- Keep it professional and consistent
- No emojis (unless specifically requested by the client)
- Use present tense (e.g., "Contains", "Manages")
- Link to related files where helpful (e.g., `/docs/custom-fields.md`)
- Avoid unnecessary technical jargon

---


---

## 📁 Template Structure

```plaintext
/custompages/          → Custom ASP pages and scripts
/docs/                 → Markdown documentation files
/sql/                  → SQL triggers, views, and data scripts
/images/               → Logos, screenshots, diagrams
README.md              → Project summary and structure

