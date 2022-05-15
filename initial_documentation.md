# Wstępna dokumentacja projektowa (w ramach kamienia milowego 1)

## Opis biznesowy
### Why

*(Jakie korzyści będzie miał użytkownik z naszego projektu? / Jaka jest przyczyna powst ania projektu? / Jaki dostrzegamy problem i chcemy go rozwiązać?)*

Hurtownia danych i system Bussiness Inteligence służący do prezentacji raportów to jedno z najlepszych narzędzi wspomagających podejmowanie strategicznych decyzji biznesowych.

Dzięki zebraniu i uspójnieniu danych z różnych źródeł w bardzo prosty sposób można stworzyć raport i wizualzację która pomoże osobom decyzyjnym w dostrzeżeniu problemów w obecnym działaniu organizacji, czy też w podjęciu dezycji w jaki sposób rozwijać, czy też modyfikować działanie firmy.

Ten sposób przechowywania danych jest również przyszłościoodporny, ponieważ system jest podzielony na warstwy. Zmiana w formacie źródłowym jednego zbioru wejściowego nie powoduje konieczności zmian całej hurtowni danych, lecz jedynie poprawkę w warstwie ETL. Podobnie w prosty sposób można zmienić dostawcę oprogramowania używanego w warstwie raportowania jeśli taka potrzeba zajdzie. 

Projekt ten powstaje, aby w intuicyjny sposób umożliwić pracownikom organizacji przeglądanie danych (które i tak są już zbierane, w celu zapewnienia poprawności działania systemu) i wyciąganie z nich wniosków mających wpływ na zyski, czy też koszty utrzymania biznesu.


### How
*(Co będzie prezentowane końcowemu użytkownikowi? / Co chcemy ułatwić?)*

Końcowy użytkownik będzie miał dostęp do różnych raportów, dzięki czemu zrozumie w jaki sposób użytkownicy korzystają z systemu. Przykładowymi wizualizacjami, które mogą powstać z systemu są:

- liczba kilometrów przejechanych przez dany rower -> które pojazdy należy serwisować w pierwszej kolejności
- z których stacji wypożycza się najwięcej rowerów? czy zmienia się to z godziną wypożyczenia? może z dniem tygodnia? pogodą? -> gdzie transportować rowery i w jakich ilościach, tak aby ich nie brakowało
- jaki jest średni czas wypożyczenia roweru? czy zależy od lokalizacji? typu użytkownika -> pozwala na szacowanie liczby rowerów, które są używane w danej chwili, potrzebne do obiczenia wolumenu zakupu nowych pojazdów
- w jakich godzinach użytkownicy korzystają z rowerów -> kiedy można zabrać rowery do serwisu
- jakie odległości pokonują użytkownicy w zależności od typu roweru? -> może należy powiększyć flotę rowerów elektrycznych
- ...


### What

*Jakie dane analizujemy (bardzo krótki opis źródła oraz co można z wyciągnąć)*

W ramach projektu analizujemy wystawione publicznie dane raportowe dotyczące wypożyczeń rowerów. Dane te są udostępniane po każdym miesiącu kalenarzowym. Jeden wiersz odpowiada jednokrotemu wypożyczeniu roweru przez jednego użytkownika. Znajdują się w nim takie dane jak:
- stacja początkowa i końcowa wypożyczenia,
- godzina rozpoczęcia i zakończenia wypożyczenia,  
- informacje o użytkowniku (płeć, rok urodzenia, typ: subskrybent/wypożyczenie okazjonalne)
- identyfikator roweru

W przypadku, gdyby rozwiązanie powstawało w porozumieniu z klientem, dane mogłyby być odświeżane częściej niż co miesiąc z transakcyjnej bazy danych (na przykład co tydzień - miesiąc w sezonie rowerowym to dość długo -> mało czasu na decyzje). Wtedy również rozwiązalibyśmy problem braku przypisania wypożyczenia do konkretnego użytkownika - w danych publicznych ta informacja musiała zostać usunięta, w celu zachowania anonimowości klientów, ale w hurtowni danych pozwoliłaby na jeszcze dogłębniejsze analizy - na przykład, czy któś nie korzysta z systemu w sposób niezgodny z regulminem, albo opracowanie zniżek dla użytkowników korzystających z systemu w sposób regularny.

Drugim źródłem informacji jest api zawierające historyczne dane pogodowe. Dzięki niemu uzyskujemy jeszcze bardziej dogłębne informacje - jak warunki pogodowe wpływają na korzystanie z systemu przez użytkowników. 


## Opis danych

## Opis architektury
### Warstwy modelu

![Schemat architektury](arch.png)

### ETL

### Ostateczny (na ten moment) model hurtowni