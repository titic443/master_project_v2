# Traditional Keyword-Driven Testing Examples

## 📋 สารบัญ
1. [Keyword-Driven Testing คืออะไร](#keyword-driven-testing-คืออะไร)
2. [ตารางเปรียบเทียบ Traditional Frameworks](#ตารางเปรียบเทียบ-traditional-frameworks)
3. [ตัวอย่าง 1: Robot Framework](#ตัวอย่าง-1-robot-framework)
4. [ตัวอย่าง 2: Selenium with Excel](#ตัวอย่าง-2-selenium-with-excel)
5. [ตัวอย่าง 3: Cucumber/Gherkin](#ตัวอย่าง-3-cucumbergherkin)
6. [ตารางเปรียบเทียบ Keywords](#ตารางเปรียบเทียบ-keywords)
7. [เปรียบเทียบกับงานวิจัยนี้](#เปรียบเทียบกับงานวิจัยนี้)

---

## Keyword-Driven Testing คืออะไร

**Keyword-Driven Testing** เป็นเทคนิคการทดสอบที่แยก **test logic** ออกจาก **test implementation** โดย:

- ใช้ **keywords** (คำสั่งระดับสูง) แทน code จริง
- **Test data** แยกจาก code
- Testers ที่ไม่เขียนโค้ดสามารถสร้าง test cases ได้
- Keywords สามารถนำกลับมาใช้ซ้ำ (reusable)

### โครงสร้างพื้นฐาน:

```text
final providers = <BlocProvider>[BlocProvider<CustomerCubit>(create: (_)=> CustomerCubit())];
```

---

## ตารางเปรียบเทียบ Traditional Frameworks

### ตาราง 1: เปรียบเทียบ Keyword-Driven Testing Frameworks

| คุณสมบัติ | Robot Framework | Selenium + Excel | Cucumber/Gherkin | งานวิจัยนี้ |
|-----------|----------------|------------------|------------------|-------------|
| **ภาษาที่ใช้เขียน Test** | Robot syntax | Excel table | Gherkin (Given-When-Then) | JSON |
| **ภาษา Implementation** | Python/Java/Any | Java/Python/C#/Any | Java/Python/Ruby/Any | Dart |
| **ระดับความยาก** | ⭐ ง่าย | ⭐⭐ ปานกลาง | ⭐ ง่าย | ⭐⭐⭐ ซับซ้อน (auto) |
| **Test Data Format** | .robot file | .xlsx / .csv | .feature file | .json |
| **Execution** | Runtime interpreter | Runtime interpreter | Runtime interpreter | **Generate code** |
| **เขียน Test Cases** | ✍️ Manual | ✍️ Manual | ✍️ Manual | 🤖 **Auto (PICT)** |
| **Test Coverage** | Manual design | Manual design | Manual design | ⭐ **Pairwise optimized** |
| **UI Extraction** | ❌ Manual | ❌ Manual | ❌ Manual | ✅ **Automatic** |
| **Readable by Non-programmer** | ✅ ใช่ | ✅ ใช่ | ✅ ใช่ | ⚠️ ต้องเข้าใจ JSON |
| **Reusability** | ✅ สูง | ✅ สูง | ✅ สูง | ✅ สูง |
| **Built-in Reporting** | ✅ HTML report | ❌ ต้องทำเอง | ✅ HTML report | ⚠️ Flutter test report |
| **Learning Curve** | ⭐⭐ ปานกลาง | ⭐⭐⭐ สูง | ⭐⭐ ปานกลาง | ⭐⭐⭐⭐ สูงมาก |
| **Best For** | Web/API/Desktop | Web testing | BDD projects | Flutter apps |
| **ตัวอย่าง Keyword** | `Input Text`, `Click Button` | `sendKeys`, `click` | `I enter username` | `tap`, `enterText` |

### ตาราง 2: Test Case Creation Process

| ขั้นตอน | Traditional (Manual) | งานวิจัยนี้ (Automated) |
|---------|---------------------|------------------------|
| **1. รวบรวมข้อมูล UI** | ✍️ Manual: ดู UI แล้วจดรายการ widget | 🤖 **Auto**: Extract จาก Dart code |
| **2. ออกแบบ Test Cases** | ✍️ Manual: คิด scenarios ทุกอัน | 🤖 **Auto**: PICT generate combinations |
| **3. เขียน Test Data** | ✍️ Manual: เขียน Excel/Robot/Gherkin | 🤖 **Auto**: Generate JSON |
| **4. เขียน Test Code** | ✍️ Manual: เขียน keywords/steps | 🤖 **Auto**: Generate Dart code |
| **5. Execute Tests** | ▶️ Run framework (runtime) | ▶️ Run Dart tests (compiled) |
| **6. Maintain Tests** | ✍️ Manual: แก้ทุกครั้งที่ UI เปลี่ยน | ⚠️ **Semi-auto**: Re-extract + regenerate |

### ตาราง 3: ข้อดี - ข้อเสีย

| Framework | ข้อดี | ข้อเสีย |
|-----------|-------|---------|
| **Robot Framework** | • อ่านง่าย เข้าใจง่าย<br>• Community ใหญ่<br>• มี libraries เยอะ<br>• Built-in reporting | • ต้องเขียน test cases เอง<br>• ไม่มี test coverage optimization<br>• Slow execution (interpreter) |
| **Selenium + Excel** | • ยืดหยุ่นสูง<br>• ใช้ Excel คุ้นเคย<br>• Customize ได้ง่าย | • ต้องเขียน executor เอง<br>• Excel จัดการยาก (version control)<br>• ไม่มี built-in reporting |
| **Cucumber/Gherkin** | • อ่านเป็นภาษาธรรมชาติ<br>• BDD approach<br>• Stakeholder เข้าใจได้ | • ต้องเขียน step definitions<br>• Redundant code ถ้า steps ซ้ำ<br>• Learning curve สูง |
| **งานวิจัยนี้** | • **Auto extract UI**<br>• **PICT optimization**<br>• **Generate code**<br>• **Pairwise coverage** | • Setup ซับซ้อน<br>• เฉพาะ Flutter เท่านั้น<br>• ต้องมี PICT tool<br>• Hard to customize |

---

## ตัวอย่าง 1: Robot Framework

### 1.1 โครงสร้างโปรเจค

```
project/
├── tests/
│   └── login_tests.robot       # Test cases
├── keywords/
│   └── login_keywords.robot    # Keyword definitions
└── libraries/
    └── selenium_lib.py         # Low-level implementation
```

### 1.2 Test Case File (login_tests.robot)

```robot
*** Settings ***
Librar SeleniumLibrary
Resource          ../keywords/login_keywords.robot

*** Test Cases ***
TC001: Successful Login
    [Documentation]    Test login with valid credentials
    [Tags]    smoke    login
    Open Login Page
    Input Username    alice@example.com
    Input Password    password123
    Click Login Button
    Verify Login Success    Welcome, Alice!
    Close Browser
```

### 1.3 Keyword Definitions (login_keywords.robot)

```robot
*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}              https://example.com/login
${BROWSER}          Chrome
${USERNAME_FIELD}   id=username
${PASSWORD_FIELD}   id=password
${LOGIN_BUTTON}     id=login-btn
${WELCOME_MSG}      xpath=//h1[@class='welcome']
${ERROR_MSG}        css=.error-message

*** Keywords ***
Open Login Page
    [Documentation]    Navigate to login page
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Page Contains Element    ${USERNAME_FIELD}

Input Username
    [Arguments]    ${username}
    [Documentation]    Enter username into input field
    Input Text    ${USERNAME_FIELD}    ${username}

Input Password
    [Arguments]    ${password}
    [Documentation]    Enter password into input field
    Input Text    ${PASSWORD_FIELD}    ${password}

Click Login Button
    [Documentation]    Click the login submit button
    Click Button    ${LOGIN_BUTTON}
    Sleep    2s    # Wait for response

Verify Login Success
    [Arguments]    ${expected_message}
    [Documentation]    Verify successful login message
    Wait Until Page Contains Element    ${WELCOME_MSG}
    Element Text Should Be    ${WELCOME_MSG}    ${expected_message}

Verify Error Message
    [Arguments]    ${expected_error}
    [Documentation]    Verify error message is displayed
    Wait Until Page Contains Element    ${ERROR_MSG}
    Page Should Contain    ${expected_error}

Close Browser
    [Documentation]    Close the browser window
    Close All Browsers
```

### 1.4 รันเทสต์

```bash
# Run all tests
robot tests/login_tests.robot

# Run specific tag
robot --include smoke tests/login_tests.robot

# Run with custom variables
robot --variable BROWSER:Firefox tests/login_tests.robot
```

### 1.5 ผลลัพธ์

```
==============================================================================
Login Tests
==============================================================================
TC001: Successful Login                                           | PASS |
------------------------------------------------------------------------------
TC002: Login with Invalid Password                                | PASS |
------------------------------------------------------------------------------
TC003: Login with Empty Fields                                    | PASS |
------------------------------------------------------------------------------
Login Tests                                                       | PASS |
3 tests, 3 passed, 0 failed
==============================================================================
```

### 1.6 ตัวอย่าง Test Case แบบเต็มรูปแบบ

ตัวอย่างนี้แสดงโครงสร้างที่สมบูรณ์ของ Robot Framework ตามมาตรฐาน:

**ไฟล์: tests/complete_login_test.robot**

```robot
*** Settings ***
Library           SeleniumLibrary
Resource          ../keywords/common_keywords.robot
Test Setup        Open Browser To Login Page
Test Teardown     Close Browser

*** Variables ***
${LOGIN_URL}      https://example.com/login
${BROWSER}        Chrome
${VALID_USER}     testuser@example.com
${VALID_PASS}     SecurePass123

*** Test Cases ***
TC001: Go to Login Page
    [Documentation]    Verify user can navigate to login page and login successfully
    [Tags]    smoke    login    critical
    Input Text        id=username       ${VALID_USER}
    Input Text        id=password       ${VALID_PASS}
    Click Button      id=login-btn
    Wait Until Page Contains    Welcome
    Page Should Contain Element    id=dashboard
    Location Should Contain    /dashboard

TC002: Login with Invalid Credentials
    [Documentation]    Verify error message displays with wrong credentials
    [Tags]    negative
    Input Text        id=username       invalid@example.com
    Input Text        id=password       wrongpass
    Click Button      id=login-btn
    Wait Until Page Contains    Invalid credentials
    Page Should Contain Element    css:.error-message
    Location Should Contain    /login

TC003: Login with Empty Username
    [Documentation]    Test validation for required username field
    [Tags]    validation
    Input Text        id=password       ${VALID_PASS}
    Click Button      id=login-btn
    Page Should Contain    Username is required
    Element Should Be Visible    css:.error-username

*** Keywords ***
Open Browser To Login Page
    [Documentation]    Navigate to login page before each test
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Maximize Browser Window
    Title Should Be    Login - Example App
```

**คำอธิบายโครงสร้าง:**

| Section | จุดประสงค์ | รายละเอียด |
|---------|-----------|-----------|
| **`*** Settings ***`** | กำหนดค่าเริ่มต้น | - `Library`: Import libraries (SeleniumLibrary)<br>- `Resource`: Import keyword files<br>- `Test Setup`: รันก่อนแต่ละ test<br>- `Test Teardown`: รันหลังแต่ละ test |
| **`*** Variables ***`** | ประกาศตัวแปร | - `${LOGIN_URL}`: URL ของหน้า login<br>- `${VALID_USER}`: Username สำหรับทดสอบ<br>- ใช้ `${variable}` syntax |
| **`*** Test Cases ***`** | Test scenarios | - แต่ละ test case มี unique name<br>- `[Documentation]`: คำอธิบาย<br>- `[Tags]`: ป้ายกำกับสำหรับกรอง<br>- Steps: keywords ที่จะรัน |
| **`*** Keywords ***`** | Custom keywords | - `Open Browser To Login Page`: keyword ที่สร้างเอง<br>- นำกลับมาใช้ได้หลายที่ |

**รันเทสต์:**

```bash
# รัน TC001 เท่านั้น
robot --test "TC001: Go to Login Page" tests/complete_login_test.robot

# รันเฉพาะ test ที่มี tag smoke
robot --include smoke tests/complete_login_test.robot

# รันทั้งหมด พร้อม output HTML
robot --outputdir results tests/complete_login_test.robot
```

**ผลลัพธ์:**

```
==============================================================================
Complete Login Test
==============================================================================
TC001: Go to Login Page                                          | PASS |
------------------------------------------------------------------------------
TC002: Login with Invalid Credentials                            | PASS |
------------------------------------------------------------------------------
TC003: Login with Empty Username                                 | PASS |
==============================================================================
Complete Login Test                                              | PASS |
3 tests, 3 passed, 0 failed
==============================================================================
Output:  /results/output.xml
Log:     /results/log.html
Report:  /results/report.html
```

**จุดเด่น:**
- ✅ **Test Setup/Teardown**: เปิด-ปิด browser อัตโนมัติ
- ✅ **Variables**: จัดการ test data แยกจาก test logic
- ✅ **Tags**: กรอง test cases ตาม categories
- ✅ **Documentation**: อธิบาย test case แต่ละตัว
- ✅ **Custom Keywords**: สร้าง keywords ใช้เองได้

---

## ตัวอย่าง 2: Selenium with Excel

### 2.1 Excel Test Data (test_data.xlsx)

| TestCaseID | Keyword    | Locator              | Value                | Description              |
|------------|------------|----------------------|----------------------|--------------------------|
| TC001      | navigate   | https://example.com  |                      | Open login page          |
| TC001      | sendKeys   | id=username          | alice@example.com    | Enter username           |
| TC001      | sendKeys   | id=password          | password123          | Enter password           |
| TC001      | click      | id=login-btn         |                      | Click login button       |
| TC001      | verify     | xpath=//h1           | Welcome, Alice!      | Verify welcome message   |
| TC002      | navigate   | https://example.com  |                      | Open login page          |
| TC002      | sendKeys   | id=username          | alice@example.com    | Enter username           |
| TC002      | sendKeys   | id=password          | wrongpassword        | Enter wrong password     |
| TC002      | click      | id=login-btn         |                      | Click login button       |
| TC002      | verify     | css=.error-message   | Invalid credentials  | Verify error message     |

### 2.2 Keyword Executor (Java)

```java
import org.openqa.selenium.*;
import org.openqa.selenium.chrome.ChromeDriver;
import org.apache.poi.ss.usermodel.*;
import java.io.FileInputStream;

public class KeywordDrivenFramework {
    WebDriver driver;

    public static void main(String[] args) throws Exception {
        KeywordDrivenFramework framework = new KeywordDrivenFramework();
        framework.executeTestCases("test_data.xlsx");
    }

    public void executeTestCases(String excelPath) throws Exception {
        // Read Excel file
        FileInputStream file = new FileInputStream(excelPath);
        Workbook workbook = WorkbookFactory.create(file);
        Sheet sheet = workbook.getSheetAt(0);

        // Execute each row
        for (int i = 1; i <= sheet.getLastRowNum(); i++) {
            Row row = sheet.getRow(i);
            String testCaseId = row.getCell(0).getStringCellValue();
            String keyword = row.getCell(1).getStringCellValue();
            String locator = row.getCell(2).getStringCellValue();
            String value = row.getCell(3).getStringCellValue();

            System.out.println("Executing: " + testCaseId + " - " + keyword);
            executeKeyword(keyword, locator, value);
        }

        if (driver != null) {
            driver.quit();
        }
    }

    public void executeKeyword(String keyword, String locator, String value) {
        switch (keyword.toLowerCase()) {
            case "navigate":
                if (driver == null) {
                    driver = new ChromeDriver();
                }
                driver.get(locator);
                driver.manage().window().maximize();
                break;

            case "sendkeys":
                WebElement inputElement = findElement(locator);
                inputElement.clear();
                inputElement.sendKeys(value);
                break;

            case "click":
                WebElement clickElement = findElement(locator);
                clickElement.click();
                Thread.sleep(2000); // Wait for response
                break;

            case "verify":
                WebElement verifyElement = findElement(locator);
                String actualText = verifyElement.getText();
                if (actualText.equals(value)) {
                    System.out.println("✓ Verification passed: " + value);
                } else {
                    System.out.println("✗ Verification failed. Expected: " + value + ", Actual: " + actualText);
                }
                break;

            case "close":
                if (driver != null) {
                    driver.quit();
                    driver = null;
                }
                break;

            default:
                System.out.println("Unknown keyword: " + keyword);
        }
    }

    private WebElement findElement(String locator) {
        if (locator.startsWith("id=")) {
            return driver.findElement(By.id(locator.substring(3)));
        } else if (locator.startsWith("xpath=")) {
            return driver.findElement(By.xpath(locator.substring(6)));
        } else if (locator.startsWith("css=")) {
            return driver.findElement(By.cssSelector(locator.substring(4)));
        } else if (locator.startsWith("name=")) {
            return driver.findElement(By.name(locator.substring(5)));
        }
        throw new IllegalArgumentException("Invalid locator: " + locator);
    }
}
```

### 2.3 รันเทสต์

```bash
javac -cp "selenium-java-4.x.jar;poi-5.x.jar" KeywordDrivenFramework.java
java -cp "selenium-java-4.x.jar;poi-5.x.jar;." KeywordDrivenFramework
```

### 2.4 ผลลัพธ์

```
Executing: TC001 - navigate
Executing: TC001 - sendKeys
Executing: TC001 - sendKeys
Executing: TC001 - click
Executing: TC001 - verify
✓ Verification passed: Welcome, Alice!

Executing: TC002 - navigate
Executing: TC002 - sendKeys
Executing: TC002 - sendKeys
Executing: TC002 - click
Executing: TC002 - verify
✓ Verification passed: Invalid credentials
```

---

## ตัวอย่าง 3: Cucumber/Gherkin

### 3.1 Feature File (login.feature)

```gherkin
Feature: User Login
  As a registered user
  I want to login to the system
  So that I can access my account

  Background:
    Given I am on the login page

  Scenario: Successful login with valid credentials
    When I enter username "alice@example.com"
    And I enter password "password123"
    And I click the login button
    Then I should see the welcome message "Welcome, Alice!"
    And I should be redirected to dashboard

  Scenario: Login fails with invalid password
    When I enter username "alice@example.com"
    And I enter password "wrongpassword"
    And I click the login button
    Then I should see error message "Invalid credentials"
    And I should remain on the login page

  Scenario Outline: Login with different user roles
    When I enter username "<username>"
    And I enter password "<password>"
    And I click the login button
    Then I should see the welcome message "<message>"

    Examples:
      | username           | password    | message          |
      | admin@example.com  | admin123    | Welcome, Admin!  |
      | user@example.com   | user123     | Welcome, User!   |
      | guest@example.com  | guest123    | Welcome, Guest!  |
```

### 3.2 Step Definitions (Python - Behave)

```python
from behave import given, when, then
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

@given('I am on the login page')
def step_open_login_page(context):
    context.driver = webdriver.Chrome()
    context.driver.get('https://example.com/login')
    context.driver.maximize_window()

@when('I enter username "{username}"')
def step_enter_username(context, username):
    username_field = context.driver.find_element(By.ID, 'username')
    username_field.clear()
    username_field.send_keys(username)

@when('I enter password "{password}"')
def step_enter_password(context, password):
    password_field = context.driver.find_element(By.ID, 'password')
    password_field.clear()
    password_field.send_keys(password)

@when('I click the login button')
def step_click_login(context):
    login_btn = context.driver.find_element(By.ID, 'login-btn')
    login_btn.click()
    # Wait for page to load
    WebDriverWait(context.driver, 10).until(
        EC.presence_of_element_located((By.TAG_NAME, 'body'))
    )

@then('I should see the welcome message "{message}"')
def step_verify_welcome(context, message):
    welcome_element = context.driver.find_element(By.XPATH, '//h1[@class="welcome"]')
    actual_message = welcome_element.text
    assert actual_message == message, f"Expected '{message}', got '{actual_message}'"

@then('I should see error message "{message}"')
def step_verify_error(context, message):
    error_element = context.driver.find_element(By.CSS_SELECTOR, '.error-message')
    actual_message = error_element.text
    assert message in actual_message, f"Expected '{message}' in '{actual_message}'"

@then('I should be redirected to dashboard')
def step_verify_dashboard(context):
    WebDriverWait(context.driver, 10).until(
        EC.url_contains('/dashboard')
    )
    assert '/dashboard' in context.driver.current_url

@then('I should remain on the login page')
def step_verify_login_page(context):
    assert '/login' in context.driver.current_url

def after_scenario(context, scenario):
    if hasattr(context, 'driver'):
        context.driver.quit()
```

### 3.3 รันเทสต์

```bash
# Run all scenarios
behave features/login.feature

# Run specific scenario
behave features/login.feature --name "Successful login"

# Generate HTML report
behave features/login.feature --format html --outfile report.html
```

### 3.4 ผลลัพธ์

```
Feature: User Login

  Scenario: Successful login with valid credentials
    Given I am on the login page                           # passed
    When I enter username "alice@example.com"              # passed
    And I enter password "password123"                     # passed
    And I click the login button                           # passed
    Then I should see the welcome message "Welcome, Alice!" # passed
    And I should be redirected to dashboard                # passed

  Scenario: Login fails with invalid password
    Given I am on the login page                           # passed
    When I enter username "alice@example.com"              # passed
    And I enter password "wrongpassword"                   # passed
    And I click the login button                           # passed
    Then I should see error message "Invalid credentials"  # passed
    And I should remain on the login page                  # passed

  Scenario Outline: Login with different user roles
    (3 scenarios passed)

3 scenarios (3 passed)
18 steps (18 passed)
```

---

## ตารางเปรียบเทียบ Keywords

### ตาราง 4: Keywords ที่ใช้ในแต่ละ Framework

| การกระทำ | Robot Framework | Selenium (Java) | Cucumber/Behave | งานวิจัยนี้ (JSON) |
|----------|----------------|-----------------|-----------------|-------------------|
| **เปิดเบราว์เซอร์** | `Open Browser` | `driver.get()` | `Given I am on the login page` | *(ไม่ใช้ เพราะเป็น Flutter)* |
| **กรอกข้อความ** | `Input Text` | `sendKeys()` | `When I enter username` | `{"enterText": {...}}` |
| **กดปุ่ม** | `Click Button` | `click()` | `And I click the login button` | `{"tap": {...}}` |
| **กดข้อความ** | `Click Link` | `findElement(By.linkText())` | `When I click "Login"` | `{"tapText": "..."}` |
| **รอให้ UI อัพเดท** | `Sleep` / `Wait Until` | `Thread.sleep()` | *(implicit in steps)* | `{"pump": true}` |
| **รอจน UI หยุด** | `Wait Until Page Contains` | `WebDriverWait` | *(implicit in steps)* | `{"pumpAndSettle": true}` |
| **Verify (Custom)** | `Verify Login Success`, `Verify Error Message` | `verify` keyword | `Then I should see the welcome message "{msg}"` | *(รวมอยู่ใน asserts)* |
| **ตรวจสอบข้อความ** | `Page Should Contain` | `assertEquals()` | `Then I should see "..."` | `{"text": "...", "exists": true}` |
| **ตรวจสอบ Element** | `Element Should Be Visible` | `isDisplayed()` | `Then element should exist` | `{"byKey": "...", "exists": true}` |
| **ปิดเบราว์เซอร์** | `Close Browser` | `driver.quit()` | *(in hooks)* | *(auto cleanup)* |

### ตาราง 5: ตัวอย่าง Test Case Syntax

| Framework | Syntax Example |
|-----------|---------------|
| **Robot Framework** | ```robot<br>Input Text    id=username    alice@example.com<br>Click Button    id=login-btn<br>``` |
| **Selenium + Excel** | Excel: `TC001 \| sendKeys \| id=username \| alice@example.com` |
| **Cucumber/Gherkin** | ```gherkin<br>When I enter username "alice@example.com"<br>And I click the login button<br>``` |
| **งานวิจัยนี้** | ```json<br>{"enterText": {"byKey": "username_field", "dataset": "..."}}<br>{"tap": {"byKey": "login_button"}}<br>``` |

### ตาราง 6: Test Data Structure

| Framework | Test Data Format | Example |
|-----------|-----------------|---------|
| **Robot Framework** | Variables in .robot file | `${USERNAME}    alice@example.com` |
| **Selenium + Excel** | Columns in Excel | `Value` column → `alice@example.com` |
| **Cucumber/Gherkin** | Examples table | ```\| username \| password \|<br>\| alice@example.com \| pass123 \|``` |
| **งานวิจัยนี้** | JSON datasets | ```json<br>"byKey": {<br>  "username_field": {<br>    "valid": ["alice@example.com"],<br>    "invalid": ["a"]<br>  }<br>}<br>``` |

---

## เปรียบเทียบกับงานวิจัยนี้

### Traditional Keyword-Driven Testing

#### ลักษณะ:
```
Tester เขียน Test Cases ด้วยมือ
        ↓
Keywords + Test Data (Excel/Robot/Gherkin)
        ↓
Keyword Executor อ่านและรัน
        ↓
Results
```

#### ตัวอย่าง Test Case:
```robot
*** Test Cases ***
Login Test
    Open Browser    https://example.com
    Input Text      id=username    alice@example.com
    Input Text      id=password    password123
    Click Button    id=login-btn
    Verify Text     Welcome, Alice!
```

**ข้อดี:**
- ✅ อ่านง่าย เข้าใจง่าย
- ✅ ไม่ต้องเขียนโค้ด

**ข้อเสีย:**
- ❌ เขียน test cases ด้วยมือทั้งหมด
- ❌ ไม่มี test coverage optimization
- ❌ ต้อง maintain test data เอง

---

### งานวิจัยนี้: Keyword-Driven + PICT + Code Generation

#### ลักษณะ:
```
Flutter UI Code (customer_details_page.dart)
        ↓
Extractor สกัดข้อมูล
        ↓
Manifest.json (metadata)
        ↓
PICT สร้าง Test Combinations (Pairwise)
        ↓
Test Data (customer_details_page.testdata.json)
        ↓
Code Generator
        ↓
Dart Test Scripts (พร้อมรัน)
```

#### ตัวอย่าง Generated Test:
```dart
testWidgets('pairwise_valid_invalid_cases_1', (tester) async {
  final w = MaterialApp(home: CustomerDetailsPage());
  await tester.pumpWidget(w);

  // Keywords: tap, tapText, enterText, pump, pumpAndSettle
  await tester.tap(find.byKey(const Key('customer_01_title_dropdown')));
  await tester.pump();
  await tester.tap(find.text('Dr.'));
  await tester.enterText(
    find.byKey(const Key('customer_02_firstname_textfield')),
    'Alice'
  );
  await tester.pump();
  await tester.tap(find.byKey(const Key('customer_07_end_button')));
  await tester.pumpAndSettle();

  // Assertions (OR logic)
  final expected = [find.byKey(const Key('customer_01_expected_success'))];
  expect(expected.any((f) => f.evaluate().isNotEmpty), isTrue);
});
```

**ข้อดี:**
- ✅ อ่านง่าย (ใช้ keywords)
- ⭐ **สกัดข้อมูลจาก UI อัตโนมัติ**
- ⭐ **PICT สร้าง test cases อัตโนมัติ** (ครอบคลุม pairwise combinations)
- ⭐ **Generate Dart code พร้อมรัน**
- ⭐ **Optimal test coverage** (ไม่ต้องเขียนทุก case)

### ตาราง 7: เปรียบเทียบแบบละเอียด

| หัวข้อ | Traditional Keyword-Driven | งานวิจัยนี้ |
|--------|---------------------------|-------------|
| **🎯 วัตถุประสงค์** | Execute test cases ด้วย keywords | **Generate** test scripts automatically |
| **📝 Test Creation** | ✍️ Manual (เขียนทุก case) | 🤖 **Auto** (PICT generate) |
| **🔍 UI Analysis** | ✍️ Manual (ดูแล้วจด) | 🤖 **Auto** (extract from code) |
| **📊 Test Coverage** | ⚠️ Depends on tester | ⭐ **Pairwise optimized** |
| **⚙️ Execution** | Runtime interpreter | Compiled Dart code |
| **🏗️ Architecture** | Keywords → Executor → Results | UI Code → Extract → PICT → Generate → Tests |
| **📦 Output** | Test results | **Dart test scripts** + results |
| **🔄 Maintenance** | แก้ keywords/test data | Re-extract + regenerate |
| **🎓 Required Skills** | ⭐ Keywords knowledge | ⭐⭐⭐ Flutter + PICT + JSON |
| **🚀 Speed** | ⚠️ Slow (interpreter) | ✅ Fast (compiled code) |
| **📈 Scalability** | ⚠️ Manual effort grows | ✅ Auto scales |

### ตาราง 8: ตัวอย่างการใช้งานจริง

| Scenario | Traditional Approach | งานวิจัยนี้ |
|----------|---------------------|-------------|
| **Form มี 5 fields, แต่ละ field มี 2 values** | ✍️ เขียน 2^5 = 32 test cases (ถ้าต้องการ full coverage) | 🤖 PICT generate ~10 cases (pairwise) |
| **เพิ่ม field ใหม่** | ✍️ เขียน test cases เพิ่ม (double จำนวน) | 🤖 Re-extract → PICT auto generate |
| **เปลี่ยนชื่อ widget** | ⚠️ แก้ใน test cases ทุกตัว | 🤖 Re-extract → auto update |
| **ต้องการ test 100% combinations** | ✍️ เขียน 100+ cases | ⚠️ PICT ไม่เหมาะ (ใช้ full coverage mode) |

### ตาราง 9: เมื่อไหร่ควรใช้อะไร

| สถานการณ์ | แนะนำ | เหตุผล |
|-----------|------|--------|
| **Web application testing** | Robot Framework / Selenium | รองรับ Web ดีที่สุด |
| **BDD project** | Cucumber/Gherkin | Stakeholder อ่านได้ |
| **Flutter app with many combinations** | **งานวิจัยนี้** | Auto generate + pairwise |
| **Simple smoke tests** | Robot Framework | เขียนง่าย รันไว |
| **Complex business logic** | Cucumber | Natural language |
| **Regression testing (stable UI)** | Selenium + Excel | ยืดหยุ่น customize ได้ |
| **New Flutter app** | **งานวิจัยนี้** | Extract UI auto |

**ข้อแตกต่างหลัก:**
- ❌ Traditional: **เขียน test cases ด้วยมือ** → Execute keywords ใน runtime
- ✅ งานวิจัยนี้: **Generate test cases อัตโนมัติ** → Generate Dart code → Run tests

---

## สรุป Keyword-Driven Testing

### แบบ Traditional:
1. **Robot Framework** - อ่านง่ายที่สุด, เหมาะกับ non-programmer
2. **Selenium + Excel** - ยืดหยุ่น, ใช้ Excel จัดการ test data
3. **Cucumber/Gherkin** - เน้น BDD, อ่านเป็นภาษาธรรมชาติ

### งานวิจัยนี้:
- ใช้แนวคิด Keyword-Driven (tap, enterText, pump, etc.)
- **เพิ่ม Automation**: PICT + Code Generation
- **เพิ่ม Intelligence**: UI extraction + Pairwise testing
- **ผลลัพธ์**: Dart code พร้อมใช้งาน (ไม่ใช่แค่ keywords)

---

## อ้างอิง

1. **Robot Framework**: https://robotframework.org/
2. **Selenium Keyword-Driven**: https://www.selenium.dev/
3. **Cucumber/Behave**: https://cucumber.io/
4. **PICT**: https://github.com/Microsoft/pict
