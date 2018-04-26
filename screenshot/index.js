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
    await page.setViewport({width: 1280, height: 1080})
    // await page.authenticate(config.proxy.auth);
    await page.goto('http://localhost:3838', {waitUntil: "networkidle0"});

    // # TOP
    console.log("Shot toppage")
    await page.screenshot({
        path: path.join(outputDir, 'comevizz_toppage.png')
    });

    // ## Read data file    
    const datasource = await page.$('input[type=file]')
    await datasource.uploadFile('./data/sample_data.csv')
    await page.waitFor(5000)
    console.log("Shot finish reading data file")
    await page.screenshot({
        path: path.join(outputDir, 'comevizz_read_data.png')
    });

    // # Z-Score Tab
    // ## Display Z-Score
    await page.type("#repository_filter", "apache/")
    await page.type("#target_filter", "commons")
    await page.waitFor(5000)
    console.log("Shot filtered z-score")
    await page.screenshot({
        path: path.join(outputDir, 'comevizz_zscore.png')
    });

    // ## Select Metrics Stats
    await page.click("#zscore_metrics_set + .selectize-control")
    await page.waitFor(500)
    console.log("Shot selecting metrics sets")
    await page.screenshot({
        path: path.join(outputDir, 'comevizz_zscore_select_sets.png')
    });
    // ## Select Metrics
    await page.click("#select_zscore_metrics input[type=text]")
    await page.waitFor(500)
    console.log("Shot selecting metrics")
    await page.screenshot({
        path: path.join(outputDir, 'comevizz_zscore_select_metrics.png')
    });

    // ## Show modal for saving radarchar as image
    await page.click("#show_save_modal[type=button]")
    await page.waitFor(1000)
    console.log("Shot modal for saving radarchart")
    await page.screenshot({
        path: path.join(outputDir, 'comevizz_zscore_save_modal.png')
    });
    // ## Check adding filter desc on radarchart
    await page.click("#save_zscore_check_desc[type=checkbox]")
    await page.waitFor(500)
    console.log("Shot checking zscore desc on radarchart")
    await page.screenshot({
        path: path.join(outputDir, 'comevizz_zscore_save_modal_check_desk.png')
    });

    // ## Close modal
    await page.keyboard.press('Escape')
    await page.waitFor(500)

    // # Metrics Stats Tab
    // ## Display metrics stats
    await page.click('a[data-value="Metrics Stats"]')
    await page.waitFor(500)
    console.log("Shot stats tab")
    await page.screenshot({
        path: path.join(outputDir, 'comevizz_stats.png')
    });
    // ## Select Metrics
    await page.click("#select_metrics + .selectize-control")
    await page.waitFor(500)
    console.log("Shot selecting stats")
    await page.screenshot({
        path: path.join(outputDir, 'comevizz_stats_select_metrics.png')
    });
    // ## Complete to display selected metrics
    await page.keyboard.press('ArrowDown')
    await page.keyboard.press('ArrowDown')
    await page.keyboard.press('Enter')
    // await page.focus('input[placeholder=choose]')
    //await page.type('bugs')
    //await page.press('Enter')
    // await page.select('#select_metrics', 'bugs')
    await page.waitFor(3000)
    console.log("Shot selected stats")
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
    console.log("Shot filtering stats")
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
    console.log("Shot normalize metrics")
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
    console.log("Shot boxcox transform")
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
