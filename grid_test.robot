*** Settings ***
Documentation               Execute robotframework tests with Selenium Grid. robotframework==3.0.2, robotframework-selenium2library==1.8.0 &  selenium==3.5.0
...
Metadata                    VERSION     1.0
Library                     Selenium2Library
Library                     Collections
Suite Setup                 Start Browser
Suite Teardown              Close Browser


*** Variables ***
${SERVER}                   https://www.google.ch
${BROWSER}                  chrome

*** Keywords ***
Start Browser
    [Documentation]         Start firefox browser on Selenium Grid
    Open Browser            ${SERVER}   ${BROWSER}   None  remote_url=http://localhost:4444/wd/hub

*** Test Cases ***
Check something
    [Documentation]         Check the page title
    Title Should Be         Google
    capture page screenshot