const puppeteer = require('puppeteer');
const config = require('./config.json');
const path = require('path'),
      fs = require('fs-extra');

const outputDir = 'images/';
const destDirs = ["../gitbook/ja/docs/comevizz/images", "../gitbook/en/docs/comevizz/images"]

if(!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir);
}
destDirs.forEach(function(val, i){
    if(!fs.existsSync(val)) {
        fs.mkdirSync(val);
    }
});

async function shot() {
    const browser = await puppeteer.launch({
        // args: ['--proxy-server=' + config.proxy.server, '--no-sandbox', '--disable-setuid-sandbox']
    });
    const page = await browser.newPage();
    await page.setViewport({width: 1280, height: 720})
    // await page.authenticate(config.proxy.auth);
    await page.goto('http://localhost:3838', {waitUntil: "networkidle"});

    // # TOP
    await page.screenshot({
        path: path.join(outputDir, 'comevizz_toppage.png')
    });

    // ## Read data file    
    const datasource = await page.$('input[type=file]')
    await datasource.uploadFile('./data/sample_data.csv')
    await page.waitFor(5000)
    await page.screenshot({
        path: path.join(outputDir, 'comevizz_read_data.png')
    });

    // # Z-Score Tab
    // ## Display Z-Score
    await page.click('a[data-value="Z-Score"]')
    await page.focus('input[type=text]')
    await page.type('Violations')
    await page.press('Enter')
    await page.focus("#repository_filter")
    await page.type("apache/")
    await page.focus("#target_filter")
    await page.type("commons")
    await page.waitFor(5000)
    await page.screenshot({
        path: path.join(outputDir, 'comevizz_zscore.png')
    });

    // ## Select Metrics Stats
    await page.click("#zscore_metrics_set + .selectize-control")
    await page.screenshot({
        path: path.join(outputDir, 'comevizz_zscore_select_sets.png')
    });
    // ## Select Metrics
    await page.click("#select_zscore_metrics input[type=text]")
    await page.screenshot({
        path: path.join(outputDir, 'comevizz_zscore_select_metrics.png')
    });

    // # Metrics Stats Tab
    // ## Display metrics stats
    await page.click('a[data-value="Metrics Stats"]')
    await page.screenshot({
        path: path.join(outputDir, 'comevizz_stats.png')
    });
    // ## Select Metrics
    await page.click("#select_metrics + .selectize-control")
    await page.screenshot({
        path: path.join(outputDir, 'comevizz_stats_select_metrics.png')
    });
    // ## Complete to display selected metrics
    await page.focus('input[placeholder=choose]')
    await page.type('bugs')
    await page.press('Enter')
    await page.waitFor(3000)
    await page.screenshot({
        path: path.join(outputDir, 'comevizz_stats_selected.png'),
        clip: {
            x: 0,
            y: 0,
            width: 1280,
            height: 1440
        }
    })

    // # Filtering and Converting
    // ## Filtering repositories
    await page.waitFor(3000)
    await page.screenshot({
        path: path.join(outputDir, 'comevizz_option_filtering.png'),
        clip: {
            x: 0,
            y: 0,
            width: 1280,
            height: 1440
        }
    });

    // ## Devided metrics value by lines
    await page.click('#calculate_density')
    await page.waitFor(1000)
    await page.screenshot({
        path: path.join(outputDir, 'comevizz_option_normalize_by_lines.png'),
        clip: {
            x: 0,
            y: 0,
            width: 1280,
            height: 1440
        }
    })
    // ## BoxCox Transformation
    await page.click('#boxcox')
    await page.waitFor(1000)
    await page.screenshot({
        path: path.join(outputDir, 'comevizz_option_boxcox.png'),
        clip: {
            x: 0,
            y: 0,
            width: 1280,
            height: 1440
        }
    })

    await browser.close();
};

Promise.resolve(shot())
    .then(function() {
        destDirs.forEach(function(val, i) {
            fs.copySync(outputDir, val);
        })
    }
);