//
//  importFilterWrapper.h
//  bart4
//
//  Created by Bartlomiej Pycinski on 11-11-11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "OsiriXApi/ViewerController.h"
#include <itkObject.h>
#include <itkImage.h>
#include "bartImportFilter.h"
typedef float myPixelType;
//typedef itk::Image <itkPixelType, 3> ImageType;
//typedef itk::ImportImageFilter <itkPixelType, 3> ImportFilterType;
//typedef bartImportFilter <itkPixelType, 3> ImportFilterType;

/** Klasa - wrapper opakowujaca importImageFilter w interfejs Objective-C
 * \TODO dokonczyc cala klase
 */
@interface importFilterWrapper : NSObject {
@private
    /** Kontroler okna OsiriXa, ustawiany w konstruktorze */
    ViewerController* viewerController;
    /** Filtr importujacy jako podklasa itk::importImageFilter */
    bartImportFilter<myPixelType,3>::Pointer importFilter;
    /** Rozmar wczytanego obrazu. Potrzebny do zwaracania wtyczce by wiedziala jaki obszar ma skopiowac
     * \NOTE moze nie bedzie potrzebny, jak rozbuduje wrapper o zapis z powrotem
     */
    int size [3];
}

/** Konstruktor. Od razu ustawua wskaznik viewerController. */
-(importFilterWrapper*) initWithViewerController: (ViewerController*) vc;
/** Funkcja wykonujaca cala "brudna robote". Moze nie byc calkowicie uniwersalna, trzeba duzo potestowac.
 * \NOTE Nie wywolywac tej funkcji spoza klasy, jest to prywatna metoda klasy
 */
//NOTE: zakomentowanie deklaracji w bloku @interface i pozostawienie w @implementation powoduje,
// ze metoda bedzie prywatna (jedyne zastrzezenie, ze mozna jej uzywac dopiero ponizej implementacji
// w kodzie programu
//-(void)GetViewerParameters;

/** Funkcja odpowiedzialna za zamiane z powrotem obrazu ITK-owego w OsiriXowy.
 */
-(void)DisplayImage  : (itk::Image<float,3>*) lastFilterOutput;

/** Wywoluje funkcje GetOutput() importFiltera.
 \return Wskaznik na obraz w wyswietlaczu.
 \TODO zmiana typu return na bardziej ogolna?
 */
-(itk::Image<float,3>*) GetOutput;
/** Zwraca rozmiar wczytanego woluminu w pikselach jako 3-wymiarowa tablica
 * \return 3-wymiarowa tablica z iloscia pikseli w poszczegolnych wymiarach
 * \see size
 */
-(int*) GetSize;
/** Wywoluje funkcje Update() importFiltera */
-(void) Update;
@end
