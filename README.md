# Expense Tracker

Expense Tracker to aplikacja mobilna do zarządzania wydatkami. Umożliwia użytkownikom rejestrowanie, edytowanie oraz analizowanie swoich wydatków. Dane są przechowywane lokalnie, a analiza wydatków jest wizualizowana za pomocą wykresów.

---

## Funkcjonalności

- **Rejestracja i logowanie**
  - Użytkownik może tworzyć konto i logować się, aby przechowywać dane lokalnie.

- **Dodawanie wydatków**
  - Formularz umożliwia wprowadzenie nazwy wydatku, kwoty, daty oraz waluty.

- **Edycja wydatków**
  - Użytkownik może modyfikować szczegóły istniejących wydatków, w tym datę.

- **Lista wydatków**
  - Wyświetla wszystkie zapisane wydatki w formie listy.

- **Analiza wydatków**
  - Generowanie wykresów przedstawiających wydatki za pomocą QuickChart API. Możliwość analizy miesięcznych wydatków.

- **Ustawienia**
  - Wybór motywu aplikacji (jasny/ciemny/systemowy).
  - Możliwość ustawienia domyślnej waluty.
  - Motyw i waluta są zapisywane lokalnie i pamiętane po ponownym uruchomieniu aplikacji.

- **Wylogowanie**
  - Funkcja wylogowania, która czyści dane użytkownika i przekierowuje do ekranu logowania.

---

## Technologie i biblioteki

- **Flutter**: Framework do budowy aplikacji mobilnych.
- **Hive**: Lokalna baza danych do przechowywania danych.
- **Riverpod**: Zarządzanie stanem aplikacji.
- **QuickChart API**: Generowanie wykresów do analizy wydatków.

---

## Instalacja

1. **Klonuj repozytorium**:
   ```bash
   git clone <URL-repozytorium>
   cd expense-tracker
   ```

2. **Zainstaluj zależności**:
   ```bash
   flutter pub get
   ```

3. **Uruchom aplikację**:
   - Na emulatorze lub fizycznym urządzeniu:
     ```bash
     flutter run
     ```

---

## Struktura projektu

- **`lib/`**
  - **`main.dart`**: Główny plik aplikacji.
  - **`models/`**: Definicje modeli (`Expense`, `User`).
  - **`screens/`**: Ekrany aplikacji (logowanie, rejestracja, dodawanie wydatków, lista, analiza).
  - **`providers/`**: Zarządzanie stanem aplikacji.

---

## Przykłady użycia

### Dodawanie wydatku
```dart
ElevatedButton(
  onPressed: () {
    final expenseBox = Hive.box<Expense>('expenses');
    final newExpense = Expense(
      title: _titleController.text,
      amount: double.parse(_amountController.text),
      date: _selectedDate,
    );
    expenseBox.add(newExpense);
    Navigator.pop(context);
  },
  child: Text('Add Expense'),
);
```

### Generowanie wykresu analizy wydatków
```dart
String chartUrl = "https://quickchart.io/chart?c={type:'bar',data:{labels:${labels},datasets:[{label:'Expenses',data:${data}}]}}";
```

---

## Ekrany aplikacji

1. **Ekran logowania**
2. **Lista wydatków**
3. **Dodawanie wydatków**
4. **Analiza wydatków** (z wykresami słupkowymi dla miesięcy)
5. **Menu boczne** (nawigacja między ekranami)

---
![side_menu](https://github.com/user-attachments/assets/720941e7-fb62-4f4b-8286-84406ed16b55)
![settings](https://github.com/user-attachments/assets/88113b8b-af78-44eb-9147-52902cfcbd11)
![settings_theme](https://github.com/user-attachments/assets/278ce2c6-f92f-415d-b1ff-7f49d765e7bb)
![settings_currency_light](https://github.com/user-attachments/assets/d03f70da-a8c7-4a02-9fb1-4e4de052e957)
![rwd_menu](https://github.com/user-attachments/assets/d262d4a0-1377-488b-a0d9-eddf75a42f01)
![rwd_home](https://github.com/user-attachments/assets/b07e8e94-c589-46c3-b82d-c6dc7c8914b0)
![rwd_expense_list](https://github.com/user-attachments/assets/e72d3847-585b-4b35-8440-35157767be54)
![register](https://github.com/user-attachments/assets/12b1b9c8-4701-4732-8f3b-884fa0317644)
![login](https://github.com/user-attachments/assets/9a1f14ec-7e1e-4b52-af3c-f715d437201c)
![home_expense_added](https://github.com/user-attachments/assets/adac7d91-2315-4b1f-895a-0718b6c44fe3)
![home](https://github.com/user-attachments/assets/5a905f66-c2c6-4e43-9b13-475ccef642bd)
![expense_list](https://github.com/user-attachments/assets/02cdd969-712b-4235-baff-b1ba2772805a)
![expense_chart](https://github.com/user-attachments/assets/b99c132d-dffb-4cfc-9303-e6075fd72bf9)
![add expense](https://github.com/user-attachments/assets/3ee74d80-5fc3-4b59-93b0-aa60a028bc94)


