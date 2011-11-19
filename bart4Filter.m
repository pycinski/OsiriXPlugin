//
//  bart4Filter.m
//  bart4
//
//  Copyright (c) 2011 Bartek. All rights reserved.
//

#import "bart4Filter.h"
#include <itkImage.h>
#include <itkBinaryThresholdImageFilter.h>

#include "bartImportFilter.h"
#import "importFilterWrapper.h"

@implementation bart4Filter


- (void) initPlugin
{
        
}


- (long) filterImage:(NSString*) menuName
{
	typedef float itkPixelType;
    typedef itk::Image <itkPixelType, 3> ImageType;
    typedef itk::BinaryThresholdImageFilter<ImageType, ImageType> BinaryThresholdImageFilterType;
 

    importFilterWrapper* wrapper = [[importFilterWrapper alloc] initWithViewerController: viewerController];
    //[wrapper Update];   //nie potrzeba, zostanie niejawnie wywolane przez Update ostaniego elemntu potoku

    
    int lowerThreshold = 120;
    int upperThreshold = 250;
    BinaryThresholdImageFilterType::Pointer thresholdFilter = BinaryThresholdImageFilterType::New();
   
    thresholdFilter->SetInput ([wrapper GetOutput]);
    thresholdFilter->SetLowerThreshold(lowerThreshold);
    thresholdFilter->SetUpperThreshold(upperThreshold);
    thresholdFilter->SetInsideValue(1000);
    thresholdFilter->SetOutsideValue(-1000);
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
    
  
    return 0;
    
}

@end
