//
//  bart4Filter.m
//  bart4
//
//  Copyright (c) 2011 Bartek. All rights reserved.
//
#include "definicje.h" 
#import "bart4Filter.h"
#include <itkImage.h>
#include <itkBinaryThresholdImageFilter.h>
#include <itkConnectedThresholdImageFilter.h>
#include <itkMeanImageFilter.h>
#include "bartImportFilter.h"
#import "importFilterWrapper.h"
#import "bart4Controller.h"

@implementation bart4Filter


- (void) initPlugin
{
            
}

- (void) executeFilter:(int)lowerValue: (int)upperValue: (int)xPosition: (int)yPosition: (int)zPosition
{
    

	typedef float itkPixelType;
    typedef itkns::Image <itkPixelType, 3> ImageType;
    //typedef itkns::BinaryThresholdImageFilter<ImageType, ImageType> BinaryThresholdImageFilterType;
    typedef itkns::ConnectedThresholdImageFilter<ImageType, ImageType> ConnectedThresholdImageFilterType;
    typedef itkns::MeanImageFilter<ImageType, ImageType> MeanImageFilterType;

    
    importFilterWrapper* wrapper = [[importFilterWrapper alloc] initWithViewerController: viewerController];
    //[wrapper Update];   //nie potrzeba, zostanie niejawnie wywolane przez Update ostaniego elemntu potoku
    
    //TODO mozna usunac te zmienne lokalne
    int lowerThreshold = lowerValue;//[lowerThresholdField intValue];
    int upperThreshold = upperValue;//[upperThresholdField intValue];
    
    MeanImageFilterType::Pointer smoothFilter = MeanImageFilterType::New();
    ConnectedThresholdImageFilterType::Pointer thresholdFilter = ConnectedThresholdImageFilterType::New();



    ImageType::SizeType radius;
    radius[0] = radius[1] = radius[2] = 2;
    smoothFilter->SetRadius(radius);

    thresholdFilter->SetLower(lowerThreshold);
    thresholdFilter->SetUpper(upperThreshold);
    thresholdFilter->SetReplaceValue(+1000);
    
    //TODO w przypadku, gdy sie najpierw ustawi rozmycie, moze sie okazac, ze punkt startowy "wypada" poza zakres
    //progowania i koncowy obraz jest caly pusty
    ConnectedThresholdImageFilterType::IndexType seed ;
    seed[0]=xPosition;
    seed[1]=yPosition;
    seed[2]=zPosition;
    thresholdFilter->AddSeed( seed );
    
    smoothFilter->SetInput([wrapper GetOutput]);
    thresholdFilter->SetInput (smoothFilter->GetOutput());
    //Ostatni element potoku koniecznie powinien wywolac Update() !
    thresholdFilter->Update();
    
    [wrapper DisplayImage: thresholdFilter->GetOutput()];
    
    //    float* resultBuff = thresholdFilter->GetOutput()->GetBufferPointer();
    //    int* pixelSize = [wrapper GetSize];
    //    //ponizszy wiersz to iloczyn sizeof(float)*size[0]*size[1]*size[2]
    //    int bufferSize = std::accumulate(pixelSize, pixelSize+3, sizeof(float), std::multiplies<int>());
    //    memcpy ([viewerController volumePtr], resultBuff, bufferSize);
    
    //[viewerController needsDisplayUpdate];
    
    //NSRunInformationalAlertPanel(@"Informacja", @"Zakonczono obrobke obrazu", @"OK", 0L, 0L);
    
    //return 0;
    
}

- (long) filterImage:(NSString*) menuName
{
    //bart4Controller* controller = 
    [[bart4Controller alloc] initWithOwner: self AndViewerController:viewerController];
    
    return 0;
    
}

- (void)resetImage 
{
    //[viewerController discardEditing];
    [viewerController revertSeries:self];    
}
@end
