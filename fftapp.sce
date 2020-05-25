///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Analiza harmonicznych sygnału za pomocą transformaty Fouriera

//Autor: Karol Kaczmarek, 2020

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//KONFIGURACJA WSTĘPNA PROGRAMU:
//W tej części możesz zmieniać domyślne wartości używane do obliczeń

clc;clear;                  //czyszczenie konsoli oraz zmiennych w pamięci - zakomentuj jeśli nie chcesz

krok=0.000001;              //krok obliczeniowy [s]
x=3;                        //ilosc narysowanych okresów - domyślnie 1 (wpływa na czytelność przebiegów)
ileharmonicznych=40;        //ile harmonicznych przeanalizować - domyślnie 20 (wpływa na czytelność wykresu harmonicznych)
u=230;                      //napięcie skuteczne [V], domyślnie 230 V (Polska)
fr=50;                      //częstotliwość podstawowa [Hz], domyślnie 50 Hz (Polska)

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//PROGRAM:
//W tej części znajdują się elementy kluczowe dla poprawnego działania programu, lepiej ich nie zmieniać

T=[0:krok:(1/fr)*x];        //wektor (macierz jednowymiarowa) czasu rysowany na osi x 

//GENEROWANIE SYGNAŁU:
//Należy stworzyć sygnał, który będzie można przeanalizować

//Funkcja generująca sygnał na podstawie numeru harmonicznej i jej amplitudy w stosunku do domyślnego napięcia skutecznego
function [wynik]=har(n,a,u)
    wynik=a*u*sqrt(2)*sin(2*%pi*fr*n*T)
endfunction

//Funkcja generująca sygnał na podstawie częstotliwości i dowolnego napięcia skutecznego
function [wynik]=syg(fre,nap)
    wynik=nap*sqrt(2)*sin(2*%pi*fre*T)
endfunction

global W
W=[]                        //Macierz zawierająca kolejne składowe

global counter
counter=size(W,1);          //Licznik (będzie potrzebny do dopisywania sygnałów do macierzy)

//INTERFEJS GRAFICZNY (GUI)
//Zmiany w tej części spowodują zmiany w wyświetlaniu programu, usunięcie czegoś może spowodować brak możliwości wywołania funkcji obliczeniowej


f=figure('figure_position',[458,85],'figure_size',[640,479],'auto_resize','on','background',[35],'figure_name','Analiza harmonicznych sygnału za pomocą transformaty Fouriera','dockable','off','infobar_visible','on','toolbar_visible','on','menubar_visible','on','default_axes','on','visible','off');

handles.dummy = 0;

handles.frame=uicontrol(f,'unit','normalized','BackgroundColor',[1,1,1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[12],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1],'HorizontalAlignment','left','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0,0,0.2,1],'Relief','default','SliderStep',[0.01,0.1],'String','','Style','frame','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','frame','Callback','')

handles.txt_nrhar=uicontrol(f,'unit','normalized','BackgroundColor',[1,1,1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[12],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0,0.95,0.2,0.05],'Relief','default','SliderStep',[0.01,0.1],'String','Numer harmonicznej:','Style','text','Value',[0],'VerticalAlignment','middle','Visible','off','Tag','txt_nrhar','Callback','')
handles.nrhar=uicontrol(f,'unit','normalized','BackgroundColor',[1,1,1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[12],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0,0.90,0.2,0.05],'Relief','default','SliderStep',[0.01,0.1],'String','1','Style','edit','Value',[0],'VerticalAlignment','middle','Visible','off','Tag','nrhar','Callback','')
handles.txt_amphar=uicontrol(f,'unit','normalized','BackgroundColor',[1,1,1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[12],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0,0.85,0.2,0.05],'Relief','default','SliderStep',[0.01,0.1],'String','Amplituda [%]:','Style','text','Value',[0],'VerticalAlignment','middle','Visible','off','Tag','txt_amphar','Callback','')
handles.amphar=uicontrol(f,'unit','normalized','BackgroundColor',[1,1,1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[12],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0,0.80,0.2,0.05],'Relief','default','SliderStep',[0.01,0.1],'String','100','Style','edit','Value',[0],'VerticalAlignment','middle','Visible','off','Tag','amphar','Callback','')


handles.txt_czestsyg=uicontrol(f,'unit','normalized','BackgroundColor',[1,1,1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[12],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0,0.95,0.2,0.05],'Relief','default','SliderStep',[0.01,0.1],'String','Częstotliwość [Hz]:','Style','text','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','txt_nrhar','Callback','')
handles.czestsyg=uicontrol(f,'unit','normalized','BackgroundColor',[1,1,1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[12],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0,0.90,0.2,0.05],'Relief','default','SliderStep',[0.01,0.1],'String','50','Style','edit','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','nrhar','Callback','')
handles.txt_napsyg=uicontrol(f,'unit','normalized','BackgroundColor',[1,1,1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[12],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0,0.85,0.2,0.05],'Relief','default','SliderStep',[0.01,0.1],'String','Napięcie skut. [V]:','Style','text','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','txt_amphar','Callback','')
handles.napsyg=uicontrol(f,'unit','normalized','BackgroundColor',[1,1,1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[12],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0,0.80,0.2,0.05],'Relief','default','SliderStep',[0.01,0.1],'String','230','Style','edit','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','amphar','Callback','')

handles.pb_dodaj=uicontrol(f,'unit','normalized','BackgroundColor',[-1,-1,-1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[12],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0,0.70,0.2,0.05],'Relief','default','SliderStep',[0.01,0.1],'String','Dodaj','Style','pushbutton','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','pb_dodaj','Callback','pb_dodaj_callback(handles)')
handles.pb_wyczysc=uicontrol(f,'unit','normalized','BackgroundColor',[-1,-1,-1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[12],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0,0.65,0.2,0.05],'Relief','default','SliderStep',[0.01,0.1],'String','Wyczyść okno','Style','pushbutton','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','pb_wyczysc','Callback','pb_wyczysc_callback(handles)')

handles.przebiegi= newaxes();handles.przebiegi.margins = [ 0 0 0 0];handles.przebiegi.axes_bounds = [0.25,0.05,0.70,0.35];handles.przebiegi.auto_clear="on";
handles.widma= newaxes();handles.widma.margins = [ 0 0 0 0];handles.widma.axes_bounds = [0.25,0.55,0.70,0.35];handles.widma.auto_clear="on";


handles.rb_syg=uicontrol(f,'unit','normalized','BackgroundColor',[1,1,1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[12],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0,0.55,0.2,0.05],'Relief','default','SliderStep',[0.01,0.1],'String','Częstotliwość i napięcie','Style','radiobutton','Value',[1],'VerticalAlignment','middle','Visible','on','Tag','rb_syg','Callback','rb_syg_callback(handles)','Groupname','rbuttons1')
handles.rb_har=uicontrol(f,'unit','normalized','BackgroundColor',[1,1,1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[12],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0,0.50,0.2,0.05],'Relief','default','SliderStep',[0.01,0.1],'String','Numer i amplituda','Style','radiobutton','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','rb_har','Callback','rb_har_callback(handles)','Groupname','rbuttons1')

f.visible = "on";

//Funkcja rysująca sumę stworzonych sygnałów przechowywanych w macierzy W na podstawie funkcji har()
function plotujhar()
global counter
global W

if isnum(handles.nrhar.string) then
    if isnum(handles.amphar.string) then
        counter=counter+1;
        W(counter,:)=har(strtod(handles.nrhar.string),strtod(handles.amphar.string)/100,u);
        wykres=0;
        for i=1:size(W,1)
            wykres=wykres+W(i,:)
        end;
        okreswykresu=wykres(1:length(wykres)/x);
        global tf;
        tf=abs(fft(okreswykresu)/length(okreswykresu)*2/(u*sqrt(2))*100);       //<----TU JEST ZAIMPLEMENTOWANA SZYBKA TRANSFORMATA FOURIERA
        widmo=tf(2:ileharmonicznych+1);                                         //Uzyskany przez zsumowanie wprowadzonych sygnałów sygnał odkształcony zostaje przetworzony
            if ~isempty(handles.przebiegi.children); then                       //z użyciem funkcji fft() do postaci wektora (macierzy jednowymiarowej), gdzie pozycja odpowiada
                delete(handles.przebiegi.children);                             //częstotliwości sygnału, a wartość jego amplitudzie. Ponieważ mogą pojawić się wartości zespolone,
            end                                                                 //to wyliczony zostaje moduł każdej z wartości, a amplituda zostaje przeskalowana jako odniesienie
            if ~isempty(handles.widma.children); then                           //do wartości domyślnej napięcia skutecznego. Na koniec, ponieważ Scilab liczy od 1, to jako pierwsza
                delete(handles.widma.children);                                 //harmoniczna wyświetlana byłaby wartość składowej zerowej, dlatego zostaje utworzony wektor widmo
            end                                                                 //zawierający odpowiednio ponumerowane harmoniczne. Wynik zostaje wyświetlony na wykresie.
        plot(handles.przebiegi,T,wykres);
        xtitle( '', 'Czas [s]', 'Napięcie [V]');
        bar(handles.widma,widmo,0.5,'blue')
        xtitle('', 'Numer harmonicznej', 'Amplituda harmonicznej [%]');
    end
else messagebox("Numer harmonicznej oraz amplituda muszą być liczbami (separator dziesiętny: '".'")", "BŁĄD")
end
endfunction

//Funkcja rysująca sumę stworzonych sygnałów przechowywanych w macierzy W na podstawie funkcji syg()
function plotujsyg()
global counter
global W

if isnum(handles.czestsyg.string) then
    if isnum(handles.napsyg.string) then
        counter=counter+1;
        W(counter,:)=syg(strtod(handles.czestsyg.string),strtod(handles.napsyg.string));
        wykres=0;
        for i=1:size(W,1)
            wykres=wykres+W(i,:)
        end;
        okreswykresu=wykres(1:length(wykres)/x);
        global tf;
        tf=abs(fft(okreswykresu)/length(okreswykresu)*2/(u*sqrt(2))*100);       //<----TU JEST ZAIMPLEMENTOWANA SZYBKA TRANSFORMATA FOURIERA
        widmo=tf(2:ileharmonicznych+1);                                         //Uzyskany przez zsumowanie wprowadzonych sygnałów sygnał odkształcony zostaje przetworzony
            if ~isempty(handles.przebiegi.children); then                       //z użyciem funkcji fft() do postaci wektora (macierzy jednowymiarowej), gdzie pozycja odpowiada
                delete(handles.przebiegi.children);                             //częstotliwości sygnału, a wartość jego amplitudzie. Ponieważ mogą pojawić się wartości zespolone,
            end                                                                 //to wyliczony zostaje moduł każdej z wartości, a amplituda zostaje przeskalowana jako odniesienie
            if ~isempty(handles.widma.children); then                           //do wartości domyślnej napięcia skutecznego. Na koniec, ponieważ Scilab liczy od 1, to jako pierwsza
                delete(handles.widma.children);                                 //harmoniczna wyświetlana byłaby wartość składowej zerowej, dlatego zostaje utworzony wektor widmo
            end                                                                 //zawierający odpowiednio ponumerowane harmoniczne. Wynik zostaje wyświetlony na wykresie.
        plot(handles.przebiegi,T,wykres);
        xtitle( '', 'Czas [s]', 'Napięcie [V]');
        bar(handles.widma,widmo,0.5,'blue')
        xtitle('', 'Numer harmonicznej', 'Amplituda harmonicznej [%]');
    end
else messagebox("Numer harmonicznej oraz amplituda muszą być liczbami (separator dziesiętny: '".'")", "BŁĄD")
end
endfunction

//Wywołanie funkcji dla wartości domyślnych (zapisanych w GUI) - rysujemy idealną sinusoidę
plotujhar();

//Funkcja powodująca wywołanie odpowiedniej funkcji po naciśnięciu przycisku "Dodaj"
function pb_dodaj_callback(handles)
global counter
global W

if handles.rb_har.Value==1 then plotujhar();
end
if handles.rb_syg.Value==1 then plotujsyg();
end
endfunction

//Funkcja powodująca wyczyszczenie wykresów oraz usunięcie sygnałów z pamięci programu po naciśnięciu przycisku "Wyczyść okno"
function pb_wyczysc_callback(handles)
global W
global tf

if ~isempty(handles.przebiegi.children); then
    delete(handles.przebiegi.children);
end
if ~isempty(handles.widma.children); then
    delete(handles.widma.children);
end

W=[]
tf=[]
endfunction

//Funkcja pozwalająca na wybór wprowadzania sygnału za pomocą numeru harmonicznej i jej amplitudy w stosunku do domyślnego napięcia skutecznego
function rb_har_callback(handles)
handles.txt_nrhar.Visible="on"
handles.nrhar.Visible="on"
handles.txt_amphar.Visible="on"
handles.amphar.Visible="on"
handles.txt_czestsyg.Visible="off"
handles.czestsyg.Visible="off"
handles.txt_napsyg.Visible="off"
handles.napsyg.Visible="off"
endfunction

//Funkcja pozwalająca na wybór wprowadzania sygnału za pomocą częstotliwości i dowolnego napięcia skutecznego
function rb_syg_callback(handles)
handles.txt_nrhar.Visible="off"
handles.nrhar.Visible="off"
handles.txt_amphar.Visible="off"
handles.amphar.Visible="off"
handles.txt_czestsyg.Visible="on"
handles.czestsyg.Visible="on"
handles.txt_napsyg.Visible="on"
handles.napsyg.Visible="on"
endfunction

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
