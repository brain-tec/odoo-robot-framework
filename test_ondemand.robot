
*** Settings ***
Documentation               Robot Framework Example for run test on Gridlastic (not working yet)
...
Metadata                    VERSION     1.0
Library                     Selenium2Library
Library                     output_video_url.py
Test Setup                  Start browser
Test Teardown               Close All Browsers


*** Variables ***
${URL}                      https://www.google.com/ncr
${BROWSER}                  internetexplorer
${ALIAS}                    None
${REMOTE_URL}               http://HMQEnMbWogEHghllxM2kkPUG0l8FQ2go:EXTSzUEN19l8gxkDacNkRyRIJPeqHkFc@A76BE8NL.gridlastic.com:80/wd/hub
${DESIRED_CAPABILITIES}     platform:VISTA,video:True,version:11


*** Keywords ***
Start Browser
    [Documentation]         Start browser on Selenium Grid
    Open Browser            ${URL}  ${BROWSER}  ${ALIAS}  ${REMOTE_URL}  ${DESIRED_CAPABILITIES}
    Maximize Browser Window

*** Test Cases ***
Test Google
    [Documentation]         Test Google
    output video url
    Input Text    q    webdriver
    Submit Form
    Wait Until Page Contains    Searches related to webdriver