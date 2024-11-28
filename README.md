# Laptime.hu_Adatbazisok2
Motorsport híroldal és fórum
Az adatbázis célja, hogy kiszolgáljon egy a motorsportok köré épülő weblapot, amely
híroldal és fórumként üzemel. A felhasználók a weblapon képesek híreket olvasni,
versenyinformációkat olvasni, valamint regisztráció és bejelentkezés után képes
hozzászólni a hírek alatt, valamint a fórumon chatszobákba csatlakozva képesek
beszélgetni is egymással. A chatszobák a különböző motorsportoknak megfelelően
vannak létrehozva.
Funkciók:
• Hírek megtekintése/feltöltése:
o A szerkesztő felhasználók képesek új híreket létrehozni. Létrehozáskor
a published mező alapértelmezetten hamis, amíg igaz nem lesz, addig
nem jelenik meg az oldalon
o A felhasználók képesek ezeket a híreket elolvasni
• Versenyhétvégék
o A felhasználók meg tudják nézni az oldalra felvitt versenyhétvégék
időpontját és a hozzájuk tartozó adatokat
o Az Adminok képesek új versenyhétvégéket létrehozni
• Regisztráció/Bejelentkezés:
o A weboldal néhány funkciója bejelentkezés után érhető csak el
o A regisztráció egy form kitöltésével végezhető el. Regisztráció során a
felhasználó megadhatja, mely motorsportok érdeklik.
▪ Ha feliratkozik a hírlevélre, akkor emailben kaphat értesítést az
új hírekről.
o Bejelentkezéskor a helyes email és jelszó páros megadásával lehet a
regisztrált fiókhoz hozzáférni
• Megjegyzések létrehozás
o A bejelentkezett felhasználók képesek a hírekhez hozzászólásokat
fűzni
• Chatszobákba való belépés és ottani kommunikáció
o A bejelentkezett felhasználók tudnak chatszobákba csatlakozni,
amelyek kategóriái az oldalon szereplő motorsport kategóriáihoz
vannak rendelve
o A chatszobába történő belépés után beszélgethetnek a felhasználók
o Az Adminok képesek új chatszobákat létrehozni, motorsport
kategóriához kötni kötelező

Táblák:
Az alábbi ábrán látható az adatbázis szerkezete. Minden created_at mező
automatikus töltődik a egy sor létrehozásakor. Az O-val jelölt mezők opcionálisak,
mivel a felhasználó létrehozásakor nem kötelező nekik megadni a kedvenceiket.
• User: A felhasználó hozhatja létre önmagának. Egy felhasználói személyt
azonosít.
o id: Egyedi azonosító, egy szekvencia állítja be a kezdőértékét, majd
onnantól folyamatosan növekszik, típusa: number, elsődleges kulcs
o first_name: A felhasználó keresztneve, típusa: varchar2(30)
o last_name: A felhasználó vezetékneve, típusa: varchar2(30)
o fav_driver: A felhasználó kedvenc pilótája, típusa: varchar2(50) – A
hosszúsága a leghosszabbnak vélt motorsport pilóta neve alapján van:
Prince Birabongse Bhanudej Bhanubandh
o fav_team: A felhasználó kedvenc csapata, típusa: varchar2(50)
o email_subscription: A felhasználó fel van-e iratkozva a hírlevélre,
típusa: boolean
o role: A felhasználó jogköre, típusa: varchar2(5)
• Motorsport: Az oldalon megtalálható különböző motorsport kategóriákat
tartalmazza. Az Admin felhasználók képesek új motorsport kategóriát
létrehozni.
o motorsport_id: Egyedi azonosító, 1-től indul és folyamatosan növekszik,
típusa: number, elsődleges kulcs
o name: A sportág neve, típusa: varchar2(20)
• Favored_Motorsport: A felhasználó beállíthatja, mely motorsportok érdeklik.
A több-több kapcsolat kezelése miatt jött létre ez a tábla
o u_id: User tábla id-ját hivatkozza meg, idegen kulcs
o motorsport_id: A Motorsport tábla motorsport_id-ját hivatkozza meg,
idegen kulcs
• News: Híreket a szerkesztők tudnak létrehozni és publikálni.
o news_id: A hír egyedi azonosítója, 1-től indul és folyamatosan
növekszik, típusa: number, elsődleges kulcs
o title: A hír címe, típusa: varchar2(50)
o description: A hír leírása, mivel hosszabb szöveg is lehet, ezért típusa
NCLOB
o motosport_category: A Motorsport tábla motorsport_id-ját hivatkozza
meg, idegen kulcs
o published: Azt jelöli, hogy a hír látható-e már a weboldalon,
alapértelmezett értéke false, típusa: boolean
o u_id: A hírt létrehozó felhasználó azonosítója, a User tábla id mezőjére
hivatkozik, idegen kulcs
• Comment: A felhasználók a hírek alatt képesek megjegyzéseket fűzni az
adott hírhez
o comment_id: Egyedi érték, a megjegyzést egyértelműen azonosítja, 1-
től indul és folyamatosan nő. Típusa: number, elsődleges kulcs

o user_id: A User tábla id mezőjét hivatkozza meg, a megjegyzés
tulajdonosát menti, idegen kulcs
o news_id: A News tábla news_id mezőjét hivatkozza meg, azt tárolja,
hogy melyik hírhez lett a hozzászólás írva, idegen kulcs
o comment: A megjegyzés leírását tartalmazza, típusa: varchar2(255)
• Chatroom: A chatszobákhoz tartozó adatokat tartalmazza. Chatszobát az
adminok hozzák létre és felügyelik azt.
o chatroom_id: A chatszoba egyedi azonosítója, 1-től indul és
folyamatosan növekszik, típusa: number, egyedi kulcs
o name: A chatszoba neve, típusa: varchar2(50)
o motorsport_category: A Motorsport tábla motorsport_id mezőjét
hivatkozza meg, egy chatszobához csak 1 motorsport kategória
rendelhető, idegen kulcs
• User_Credential: A felhasználó bejelentkezéséhez szükséges adatokat
tárolja
o u_id: A User tábla id mezőjét hivatkozza, idegen kulcs
o email: A felhasználó azonosításához használt e-mail címet menti, @
megléte kikötés. Típusa: varchar2(100)
o password: A bejelentkezéshez szükséges jelszót menti el titkosítva,
típusa: varchar2(n) ahol n a titkosító algoritmus által visszaadott
szöveghossz
• Race: A különböző versenyhétvégékhez tartozó adatokat menti. Ezeket a
verseny időpontokat az Adminok hozhatják létre
o race_id: A versenyhétvégéhez tartozó egyedi azonosító, 1-től indul és
folyamatosan nő, típusa: number, elsődleges kulcs
o motorsport_id: A Motorsport tábla motorsport_id mezőjét hivatkozza
meg, egy versenyhétévégéhez csak 1 motorsport kategória rendelhető,
idegen kulcs
o title: A versenyhétvége megnevezése, típusa: varchar2(120)
o layout_pic: A versenypálya vonalának rajzát tartalmazó kép helye,
típusa: varchar2(255)
o country: A versenyhétvégének otthont adó ország, típusa: varchar2(50)
o race_date_start: A versenyhétvége első napja, típusa: date
o race_date_end: A versenyhétvége utolsó napja, típusa: date
o air_tempareture: A versenyen várható levegő átlaghőmérséklete,
típusa: number
o asp_tempareture: A versenyen várható aszfalt átlaghőmérséklete,
típusa: number
o wind_strength: A versenyen várható szél ereje, típusa: number (km/h)
o wind_direction: A versenyen várható szél iránya, ha az erősség meg
van adva, típusa: char(2)
o rain_percentage: A versenyen várható eső esélye, típusa: number (%)
o record_time: A pályához tartozó rekord köridőt tartalmazza, típusa:
number (ms)
Név: Kuti Zoltán
Neptun-kód: XZD47P
• Log: A webalkalmazáshoz tartozó logokat menti el, a táblát nem lehet Updateelni
o log_id: Egyedi azonosító a log-okhoz, típusa: number, elsődleges kulcs
o type: A log típusa, karakterrel azonosítja, milyen típusú az adott log
bejegyzés, típusa: char
o message: A loghoz tartozó üzenet tartalmazza, típusa: varchar(255)
Táblák kapcsolatai:
PL/SQL komponensek:
• Szekvencia:
o user_seq: 1000-től indul és a User tábla id-mezőjének értékét adja meg
• Trigger:
o tr_User_id: User táblába történő beszúrás előtt a user_seq
szekvenciából nyeri ki az id mező értékét
o tr_User_email: A user beszúrása előtt ellenőrzi, hogy az email
megfelel-e az email címek formai előírásainak
• Nézetek:
o vw_most_comments: Megmutatja melyik hírek alatt a legaktívabb a
kommentszekció
o vw_newsletter: Azon felhasználókat listázza ki, akik fel vannak
iratkozva a hírlevélre
o A versenykategóriákra vonatkozó pontállásokat kilistázó nézeket.
• Eljárás:
o prc_change_role: Eljárás, amely segítségével megváltoztatható az
adott felhasználó jogköre.
