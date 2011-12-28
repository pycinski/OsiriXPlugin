#ifndef bartImportFilter_h
#define bartImportFilter_h
//
//  bartImportFilter.h
//  bart4
//
//  Created by Bartlomiej Pycinski on 11-11-07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#include "definicje.h"
#include <itkImportImageFilter.h>
#include <itkImage.h>

//TODO: komentarze w calym tym pliku
template <typename TPixel, unsigned int VImageDimension=2>
class bartImportFilter : public itkns::ImportImageFilter< TPixel, VImageDimension > {
    
public:
    typedef bartImportFilter                                    Self;
    typedef itkns::ImportImageFilter<TPixel, VImageDimension>     Superclass;
    typedef itkns::SmartPointer<Self>                             Pointer;
    typedef itkns::SmartPointer<const Self>                       ConstPointer;
    
    typedef typename Superclass::SizeType SizeType;
    typedef typename Superclass::OriginType OriginType;
    typedef typename Superclass::IndexType IndexType;
    typedef typename Superclass::SpacingType SpacingType;
    typedef typename Superclass::RegionType RegionType;
    typedef TPixel PixelType;
    //troche naokolo w ponizszy sposob:
    //typedef typename Superclass::OutputImageType::PixelType PixelType;
    
    /** Tworzenie przez funkcje statyczna New() */
    itkNewMacro(Self);
    /** W celu zgodnosci z biblioteka */
    itkTypeMacro(bartImportFilter, itkns::ImportImageFilter);
    
    /** Dodatkowa funkcja majaca ulatwic koncowemu uzytkownikowi rozwijanie wtyczki. 
     \note funkcja chyba powinna byc oznaczona jako virtual
     \note byc moze wrzucic te funkcje do konstruktora lub cos takiego, zeby nie trzeby bylo nawet jej wywolywac?
     */
    void setInputParameters(const int size[VImageDimension], const float* buffer, const float spacing [VImageDimension], const float origin[VImageDimension], const bool deleteImportBuffer=false );
    
protected:
    /** Konstruktor domyslny. Oznaczony jako protected, jedynie wywoluje konstruktora klasy bazowej */
    bartImportFilter();
    /** Desktruktor. Nie wykonuje zadnych operacji, niejawnie wywoluje desktruktora klasy nadrzednej */
    virtual ~bartImportFilter();
    
private:
    /** Celowo zablokowany konstruktor kopiujacy */
    bartImportFilter(const bartImportFilter&);
    /** Celowo zablokowany operator przypisania */
    void operator= (const bartImportFilter&);
    
    bool m_deleteImportBuffer;
    SizeType m_size;
    IndexType m_start;
    RegionType m_region;
    SpacingType m_spacing;
    OriginType m_origin ;
    //NOTE albo mozna tak zdefiniowac, wtedy nie trzeba robic typedef wczesniej
	//typename Superclass::RegionType m_region;
    PixelType* m_pixelData;
    unsigned int m_totalNumberOfPixels;
    
};



//////////////////////////////////////////////////////////////////////////////////////

template <typename TPixel, unsigned int VImageDimension>
void bartImportFilter<TPixel, VImageDimension>
::setInputParameters(const int size[VImageDimension], const float* buffer, const float spacing [VImageDimension], const float origin[VImageDimension], const bool deleteImportBuffer )
{
    
    m_deleteImportBuffer = deleteImportBuffer;
    //TODO cos z tym zrobic
    // Rzutowanie w tej chwili jest bez sensu, bo i tak wszystko to sa floaty, a gdyby sprobowac
    // stworzyc obiekt z parametrem double, do sie wysypie, bo nie moze rzutowac float* na double*  
    m_pixelData = const_cast<PixelType*>(static_cast<const PixelType*>(buffer));
    
    //kopiuj pobrane parametry do prywatnych skladowych. Uzywa metody copy, bo nie wiadomo,
    //jaki jest wymiar obrazka (zwykle 2 lub 3) czyli rozmiar wektora oraz jakie sa dane
    //wyjsciowe (prawie na pewno double), a funkcja copy kopiuje skladnik po skladniku, dokonujac
    //ewentualnych konwersji (o ile sa mozliwe)
    try {
        ///acuumulate zwraca wynik funkcji wykonanej na wszystkich elementach kolekcji, w tym wypadku
        //jest to iloczyn elementow tablicy size, argument 1 to wartosc poczatkowa
        m_totalNumberOfPixels = std::accumulate(size, size+VImageDimension, 1, std::multiplies<int>());
        std::copy (size, size+VImageDimension, m_size.m_Size);
        std::copy (spacing, spacing+VImageDimension, m_spacing.Begin());
        std::copy (origin, origin+VImageDimension, m_origin.Begin());
        m_start.Fill (0);
    }
    ///NOTE itk::ExceptionObject dziedziczy po std::exception, nie ma potrzeby go dolaczac!
    catch (std::exception &e) {
        std::cerr << "Nie moge skopiowac! Blad!\n";
        throw;
    }
    m_region.SetSize (m_size);
    m_region.SetIndex (m_start);
    this->SetRegion (m_region);
    this->SetSpacing (m_spacing);
    this->SetOrigin (m_origin);
    
    
    this->SetImportPointer (m_pixelData, m_totalNumberOfPixels, m_deleteImportBuffer);
    //this->Update();
    return;
    
}






template <typename TPixel, unsigned int VImageDimension>
bartImportFilter<TPixel, VImageDimension>
::bartImportFilter()
: Superclass ()
{
    
}


template <typename TPixel, unsigned int VImageDimension>
bartImportFilter<TPixel, VImageDimension>
::~bartImportFilter()
{
    
}



/*itk::Size<VImageDimension> m_size;
    itk::Index<VImageDimension> m_start;
    itk::ImageRegion<VImageDimension> m_region;
    itk::Vector<double, VImageDimension> m_spacing;
    itk::Point<double, VImageDimension> m_origin;
    */

#endif
