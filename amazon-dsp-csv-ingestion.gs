/**
 * Amazon DSP CSV Automation Script
 * --------------------------------
 * This Google Apps Script automates the ingestion of Amazon DSP daily CSV reports.
 * It fetches the report from an emailed link, downloads the CSV, parses the data,
 * and appends it to a designated Google Sheet before the daily ETL pipeline via Daasity.
 *
 * Author: Danny Lashkari
 * Repo: https://github.com/analytisor/amazon-dsp-automation
 */

function processAmazonDSPCSVFromLink() {
  const senderEmail = "no-reply@amazon.com";
  const subjectKeyword = "AMAZON DSP - DAILY CSV REPORT";
  const fileNamePrefix = "AMAZON_DSP_-_DAILY_CSV_REPORT_";
  const sheetId = "1XOkD7V30TIvzmj0dW_LxhZIKjQ0C4SLSbudOaumKrGg";
  const sheetName = "AMAZON_DSP";
  const sheet = SpreadsheetApp.openById(sheetId).getSheetByName(sheetName);

  if (!sheet) {
    console.error(`Sheet with name '${sheetName}' not found.`);
    return;
  }

  const today = new Date();
  today.setUTCHours(0, 0, 0, 0);

  const threads = GmailApp.search(`from:"${senderEmail}" subject:"${subjectKeyword}" newer_than:1d`);
  
  threads.forEach(thread => {
    thread.getMessages().forEach(message => {
      const emailDate = message.getDate();
      emailDate.setUTCHours(0, 0, 0, 0);

      if (emailDate.getTime() !== today.getTime()) return;

      const body = message.getBody();
      const links = extractLinksFromEmailBody(body);

      links?.forEach(link => {
        if (link.includes('.csv')) {
          try {
            const s3UrlMatch = link.match(/CL0\/([^\/]+)/);
            if (!s3UrlMatch?.[1]) return;

            const decodedS3Url = decodeURIComponent(s3UrlMatch[1]);
            const options = {
              followRedirects: true,
              muteHttpExceptions: true,
              headers: {
                "User-Agent": "Mozilla/5.0",
                "Accept": "text/csv,application/csv,application/octet-stream"
              }
            };

            const response = UrlFetchApp.fetch(decodedS3Url, options);

            if (response.getResponseCode() === 200) {
              const csvData = Utilities.parseCsv(response.getContentText());
              const dataWithoutHeader = csvData.slice(1);

              if (dataWithoutHeader.length > 0) {
                sheet.getRange(sheet.getLastRow() + 1, 1, dataWithoutHeader.length, dataWithoutHeader[0].length)
                     .setValues(dataWithoutHeader);
              }
            } else {
              console.warn(`Fetch failed. Code: ${response.getResponseCode()}`);
            }
          } catch (err) {
            console.error(`Error processing CSV link: ${link}`, err);
          }
        }
      });
    });
  });
}

/**
 * Extracts all anchor href links from an HTML email body
 */
function extractLinksFromEmailBody(body) {
  const links = [];
  const regex = /<a [^>]*href="([^"]+)"[^>]*>/g;
  let match;
  while ((match = regex.exec(body)) !== null) {
    links.push(match[1]);
  }
  return links;
}
