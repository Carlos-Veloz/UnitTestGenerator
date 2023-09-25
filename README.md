# PoC-Unit-Test-Generator
This project was created as a proof of concept using openai to generate unit tests for any framework (Technology) by providing a path and a file name.

## Installation
Clone this repository into your local machine
```
git@github.com:Carlos-Veloz/UnitTestGenerator.git
cd UnitTestGenerator
```
Install dependencies by running
```
npm install
```
In order for you to use this project you will need to create an account on [OpenAI](https://openai.com/) then refer to [Authentication](https://platform.openai.com/docs/api-reference/authentication) to understand how to generate your APIKey which you will have to place in a .env file with the following name.
```
OPENAI_API_KEY="Your_OpenAI_APIKey"
```

## Getting started
Once you have installed all dependencies required and added this PoC as another folder to the project where you want to create the unit tests from, just go to generate.js and provide next information:

Folder for source code
```
const inputFiles = "..relative path to the folder"
```
Indicate the technology
```
const framework = "Java"
```

Unit Test will be generated in /output/UT{FileName.ext}
