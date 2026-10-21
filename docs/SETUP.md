# Налаштування середовища (macOS)

Цей документ для людини, а не для Claude Code. Його проходять один раз на початку (етап M0 у роадмапі). Розрахуйте на один вечір: найдовша частина — Android SDK.

Що буде встановлено: Homebrew, Godot 4.7, OpenJDK 17, Android SDK (через Android Studio), Claude Code. Git у вас уже є.

> Версії інструментів змінюються. Якщо щось не збігається, звіряйтеся з офіційною сторінкою Godot «Exporting for Android» для вашої версії рушія і з документацією Claude Code: https://docs.claude.com/en/docs/claude-code/overview

---

## 1. Homebrew

Перевірте, чи встановлено:

```bash
brew --version
```

Якщо ні — встановіть за інструкцією на https://brew.sh.

## 2. Godot

1. Завантажте **Godot 4.7.x (стандартна версія, не .NET)** для macOS з https://godotengine.org/download і перенесіть `Godot.app` у теку «Програми». Альтернатива: `brew install --cask godot`.
2. Перший запуск: якщо macOS блокує застосунок, відкрийте його через правий клік → «Відкрити».
3. Додайте команду `godot` для терміналу (її використовує Claude Code):

```bash
echo 'alias godot="/Applications/Godot.app/Contents/MacOS/Godot"' >> ~/.zshrc
source ~/.zshrc
godot --version
```

> Аліас працює в інтерактивному терміналі. Якщо Claude Code не бачить команди `godot`, створіть символічне посилання замість аліасу:
> `sudo ln -s /Applications/Godot.app/Contents/MacOS/Godot /usr/local/bin/godot`

## 3. Java (OpenJDK 17)

Godot 4 для збірки Android потребує JDK 17.

```bash
brew install --cask zulu@17
/usr/libexec/java_home -V
```

Запам’ятайте шлях до JDK 17, зазвичай це `/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home`.

## 4. Android SDK

Найпростіше отримати SDK через Android Studio (саму Android Studio для розробки використовувати не потрібно).

```bash
brew install --cask android-studio
```

1. Запустіть Android Studio й пройдіть майстер першого запуску (Standard).
2. Відкрийте **More Actions → SDK Manager**.
3. На вкладці **SDK Platforms** переконайтеся, що встановлено актуальну стабільну платформу Android.
4. На вкладці **SDK Tools** увімкніть: Android SDK Build-Tools, Android SDK Command-line Tools (latest), Android SDK Platform-Tools. Натисніть Apply.
5. Шлях до SDK зазвичай `~/Library/Android/sdk` (показано вгорі вікна SDK Manager).

Точні версії Build-Tools і платформи, які очікує ваша версія Godot, вказані на сторінці «Exporting for Android» у документації Godot.

## 5. Налаштування Godot для Android

> Налаштування редактора доступні лише **всередині відкритого проєкту**, а не у вікні Project Manager. Тому спершу виконайте крок 8 (створення репозиторію та проєкту), а потім поверніться сюди.

1. У відкритому проєкті: меню **Editor → Editor Settings…** На macOS це меню знаходиться в системному рядку меню вгорі екрана (поруч з яблучком), коли активне вікно Godot. У вікні налаштувань введіть `android` у поле фільтра зліва вгорі або знайдіть розділ **Export → Android**.
2. **Java SDK Path:** шлях із кроку 3.
3. **Android SDK Path:** шлях із кроку 4 (розгорніть `~` у повний шлях, наприклад `/Users/ім’я/Library/Android/sdk`).
4. **Debug Keystore:** зазвичай Godot створює його автоматично. Якщо поле порожнє, згенеруйте вручну і вкажіть шлях до файлу (користувач `androiddebugkey`, пароль `android`):

```bash
keytool -keyalg RSA -genkeypair -alias androiddebugkey -keypass android \
  -keystore ~/debug.keystore -storepass android \
  -dname "CN=Android Debug,O=Android,C=US" -validity 9999 -deststoretype pkcs12
```

## 6. Телефон

1. На телефоні: **Налаштування → Про телефон** → 7 разів торкніться «Номер збірки», щоб увімкнути режим розробника.
2. **Параметри розробника → Налагодження через USB** — увімкнути.
3. Підключіть телефон кабелем і погодьтеся на запит «Дозволити налагодження» на телефоні.
4. Перевірте, що Mac бачить телефон:

```bash
~/Library/Android/sdk/platform-tools/adb devices
```

У списку має з’явитися пристрій зі статусом `device`.

**Корисно (необов’язково):** `brew install scrcpy`, потім команда `scrcpy` показує екран телефона на Mac — зручно для запису відео й демонстрацій.

## 7. Перший запуск на телефоні

Це робиться в межах етапу M0, коли проєкт уже створено.

1. У Godot: **Project → Export → Add… → Android**.
2. «Use Gradle Build» залиште вимкненим (для MVP не потрібно).
3. У розділі **Permissions** увімкніть `Vibrate`.
4. Закрийте вікно експорту. Угорі праворуч у редакторі з’явиться значок Android (Remote Debug / One-click deploy). Натисніть його й оберіть телефон.
5. Гра встановиться і запуститься на телефоні. Помилки й `print()` видно в нижній панелі Godot.

Файл `export_presets.cfg` можна комітити: паролі Godot зберігає окремо в `.godot/`, яка ігнорується Git.

## 8. Репозиторій

```bash
mkdir spark-climb && cd spark-climb
git init
# скопіюйте сюди CLAUDE.md, .gitignore і теку docs/
git add . && git commit -m "docs: initial project documentation"
```

Потім у Godot Project Manager натисніть **Create** і заповніть діалог:

- **Project Name:** `spark-climb`.
- **Project Path:** тека `spark-climb` (та сама, де лежить `CLAUDE.md`). Godot попередить, що тека не порожня, — це нормально, продовжуйте.
- **Renderer:** **Compatibility**.
- **Version Control Metadata:** **None** (Git-репозиторій і `.gitignore` у нас уже є).

Натисніть **Create & Edit** — відкриється редактор проєкту.

## 9. Claude Code

Встановлення (нативний інсталятор):

```bash
curl -fsSL https://claude.ai/install.sh | bash
claude --version
```

Альтернатива: `brew install --cask claude-code`. Для роботи потрібна платна підписка Claude або API-ключ; при першому запуску відкриється браузер для входу.

Запуск — завжди з кореня проєкту, щоб Claude Code підхопив `CLAUDE.md`:

```bash
cd spark-climb
claude
```

### Корисні прийоми

- **Plan Mode** (Shift+Tab, поки не з’явиться режим планування): Claude аналізує й пропонує план, нічого не змінюючи. Добре для початку кожної задачі.
- **`@файл`** у повідомленні додає файл у контекст: `@docs/GAME_SPEC.md`.
- **`/clear`** очищує контекст розмови. Робіть це між задачами: менше плутанини, і Claude перечитає `CLAUDE.md`.
- **Esc** зупиняє Claude посеред дії, якщо він пішов не туди.
- Claude питає дозволу перед командами терміналу й змінами файлів. Читайте, що він пропонує, — це частина навчання.
- Якщо щось незрозуміло в коді: «Поясни, як працює `player.gd`, рядок за рядком» — нормальний запит.

### Перша сесія

```
Прочитай CLAUDE.md і всі файли в docs/. Коротко перекажи, як ти зрозумів
проєкт, назви неоднозначності, якщо помітив, і запропонуй план першої
незакритої задачі з ROADMAP.
```

### Щоденний цикл

0. **На початку нового етапу** Claude Code сам перевірить, що попередня гілка змержена в `main`, і створить нову гілку `milestone/m<N>-…` (див. «Git-процес» у `CLAUDE.md`). Наприкінці етапу ви пушите гілку й мержите її в `main` самостійно.
1. Відкрити `docs/ROADMAP.md`, обрати наступну задачу.
2. `/clear`, потім у Plan Mode: «Візьми задачу "<назва>" з ROADMAP, запропонуй план».
3. Погодити або скоригувати план, вийти з Plan Mode, дати виконати.
4. Прочитати пояснення Claude; поставити питання, якщо щось незрозуміло.
5. Перевірити на ПК (`godot --path .` або F5 у редакторі), потім на телефоні.
6. Якщо все добре: попросити позначити задачу в ROADMAP і закомітити із запропонованим повідомленням. Якщо ні: описати, що не так, — або `git restore .`, щоб відкотити й почати заново.
