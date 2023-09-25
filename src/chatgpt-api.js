const OpenAI = require('openai'),
 fs = require('fs'),
 path = require('path');

require("dotenv").config();


const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY
});

module.exports = {
  async contentMsg(framework, code) {
    //return "Could you generate unit test in " + framework +" framework, showing at least two unit tests per function, one positive and one negative scenario, containing relevant assertions and all required packages within a single " + framework +"  class? The source code is the following: " + code;
    return "Could you generate unit test in " + framework + "framework, verifying store dispatches of failure and success actions of run method, use GenerateNiceMocks tool to generate external dependencies. The source code is the following: " + code;
  },

  async readFileAsCode(filePath, file) {
    try {
      let folder = path.join(filePath);
      let fileData = fs.readFileSync(path.join(__dirname, folder + file), 'utf-8');
      return fileData;
    } catch (error) {
      throw new Error(`Error reading file: ${error}`);
    }
  },

  async generateUnitTest(prompt) {
    const spinner = (await import("ora"))
      .default("Please Wait Generating Unit Test...")
      .start();

    try {
      const response = await openai.chat.completions.create({
        model: "gpt-3.5-turbo",
        messages: [
          {
            role: "user",
            content: prompt,
          },
        ],
        temperature: 0.2,
        max_tokens: 2048,
      });

      const { message } = response.choices[0];
      output = message.content;
      spinner.succeed("Unit Tests generated");
      return output;
    } catch (error) {
      spinner.fail(`Error generating unit test: ${error}`);
    }
  },

  async createOutputFiles(file, output) {
    //path where unit test file is created
    const outputFolder = "./output/";
    let fileName = path.join(outputFolder + "UT" + file);
    try {
      fs.writeFileSync(fileName, output);
      console.log(`Message written to file: ${fileName}`);
    } catch (error) {
      console.error(`Error writing to file: ${error}`);
    }
  },
}