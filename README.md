# WaterReminder — iOS приложение (SwiftUI)

## Структура проекта

```
WaterReminder/
├── WaterReminderApp.swift      ← точка входа (@main)
├── Models.swift                ← модели данных
├── WaterViewModel.swift        ← вся бизнес-логика
├── NotificationManager.swift   ← уведомления
└── Views/
    ├── ContentView.swift       ← TabView (3 вкладки)
    ├── HomeView.swift          ← главный экран
    ├── StatisticsView.swift    ← статистика / графики
    └── SettingsView.swift      ← настройки
```

## Как создать проект в Xcode (Mac)

1. Открой **Xcode** → **Create New Project**
2. Выбери **iOS → App**
3. Заполни:
   - **Product Name:** `WaterReminder`
   - **Interface:** `SwiftUI`
   - **Language:** `Swift`
   - **Minimum Deployments:** iOS 16 (для Charts)
4. Нажми **Next** → выбери папку → **Create**
5. Удали существующий файл `ContentView.swift`
6. Перетащи **все файлы** из этой папки в навигатор Xcode (убедись что стоит галочка **"Add to target"**)
7. В `Info.plist` добавь ключ:
   ```
   NSUserNotificationsUsageDescription = "Приложение отправляет напоминания пить воду"
   ```
8. Нажми **Run** (▶) или **Product → Archive** для сборки IPA

---

## Возможности приложения

| Функция | Описание |
|---|---|
| Прогресс-круг | Показывает % выполнения дневной цели |
| Отметка стакана | Кнопка "Выпил стакан" с виброотдачей |
| Журнал за день | Список всех выпитых стаканов с временем |
| Отмена последнего | Кнопка для удаления последней записи |
| Уведомления | Каждые N часов с 8:00 до 22:00 |
| Статистика | График за 7 дней + общая статистика |
| Настройки | Цель, объём стакана, интервал уведомлений |
| Сброс данных | Очистка всей истории |

## Требования

- iOS 16.0+
- Xcode 14+
- Swift 5.7+

## Подписание

При наличии сертификата:
1. Xcode → **Signing & Capabilities**
2. Выбери свою **Team** и укажи **Bundle Identifier**
3. **Product → Archive → Distribute App**
