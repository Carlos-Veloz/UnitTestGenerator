const {
  contentMsg,
  generateUnitTest,
  createOutputFiles,
} = require("./chatgpt-api"),
  fs = require("fs"),
  path = require("path"),
  async = require('async');;

const framework = "Dart";

(async () => {
  try {
    let folderPath = path.join(__dirname, inputFiles),
      validFolder = fs.readdirSync(folderPath);
    async.each(validFolder, async function (file) {
      let fileData = fs.readFileSync(path.join(__dirname, inputFiles + '/' + file), "utf-8");
      let prompt = await contentMsg(framework, fileData);
      let output = await generateUnitTest(prompt);
      await createOutputFiles(file, output);
    });
    /*const code = await readFileAsCode(path, file);
    let prompt = await contentMsg(framework, code);
    let output = await generateUnitTest(prompt);
    await createTestSuitFile(file, output);*/

  } catch (error) {
    console.error(error);
  }
})();