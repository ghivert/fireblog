const functions = require('firebase-functions')

const puppeteer = require('puppeteer')
const fetch = require('node-fetch')

let htmlPage

const selectHtmlPage = async () => {
  if (htmlPage) {
    return htmlPage
  } else {
    const res = await fetch('http://localhost:5000/index.html')
    const html = await res.text()
    htmlPage = html // eslint-disable-line
    // The previous line allow to do some caching on html page value.
    return html
  }
}

const runtimeOptions = {
  memory: '2GB',
  timeoutSeconds: 300,
}

const ssr = functions.runWith(runtimeOptions).https.onRequest(async (request, response) => {
  try {
    if (request.path.endsWith('/favicon.ico')) {
      response.status(404).end()
    } else {
      const browser = await puppeteer.launch({ headless: true })
      const page = await browser.newPage()
      const html = await selectHtmlPage()
      await page.goto('http://localhost:5000/index.html')
      const { path } = request
      await page.evaluate(path => window.history.pushState({}, '', path), path)
      await page.setContent(html, {
        waitUntil: ['networkidle0', 'domcontentloaded'],
      })
      const content = await page.content()
      response.send(content)
      await page.close()
    }
  } catch (error) {
    console.warn(error)
    response.status(500).end()
  }
})

module.exports = {
  ssr,
}
