//
//  bart4Filter.m
//  bart4
//
//  Copyright (c) 2011 Bartek. All rights reserved.
//

#import "bart4Filter.h"
#include <itkImage.h>
//#include <itkImageFileReader.h>
//#include <itkImageFileWriter.h>
#include <itkImportImageFilter.h>
#include <itkBinaryThresholdImageFilter.h>
#include <itkInvertIntensityImageFilter.h>
#include <itkMetaDataDictionary.h>
//#include <itkGDCMSeriesFileNames.h>
#include <itkGDCMImageIO.h>
#include <itkNumericSeriesFileNames.h>
#include <itkRGBPixel.h>
#include <itkComposeRGBImageFilter.h>


#include "bartImportFilter.h"
#import "importFilterWrapper.h"

@implementation bart4Filter



- (long) filterImage:(NSString*) menuName
{
	typedef float itkPixelType;
    typedef itk::Image <itkPixelType, 3> ImageType;
    //typedef itk::ImportImageFilter <itkPixelType, 3> ImportFilterType;
    typedef bartImportFilter <itkPixelType, 3> ImportFilterType;
    
    typedef itk::BinaryThresholdImageFilter<ImageType, ImageType> BinaryThresholdImageFilterType;
    
    DCMPix  *firstPix =[ [viewerController pixList] objectAtIndex:0 ];
    int slices = [[viewerController pixList] count];
    long bufferSize;
    
    ImportFilterType::Pointer importFilter = ImportFilterType::New();
    int size [3];
    //ImportFilterType::IndexType start;
    //ImportFilterType::RegionType region;
    
    //start.Fill(0);  //ustaw polozenie indeksu w punkcie 0
    
    size[0] = [firstPix pwidth];
    size[1] = [firstPix pheight];
    size[2] = slices;
    
    bufferSize = size[0]*size[1]*size[2];
    
    float origin[3];
    float originConverted [3];
    double vectorOriginal [9];
    float voxelSpacing [3];
    
    origin[0] = [firstPix originX];
    origin[1] = [firstPix originY];
    origin[2] = [firstPix originZ];
    
    [firstPix orientationDouble: vectorOriginal];
    //originConverted[0] = origin[0]*vectorOriginal[0] + origin[1]*vectorOriginal[1] + origin[2]*vectorOriginal[2];
    //originConverted[1] = origin[0]*vectorOriginal[3] + origin[1]*vectorOriginal[4] + origin[2]*vectorOriginal[5]; 
    //originConverted[2] = origin[0]*vectorOriginal[6] + origin[1]*vectorOriginal[7] + origin[2]*vectorOriginal[8];
    originConverted[0] = std::inner_product(origin,origin+3,vectorOriginal,0);
    originConverted[1] = std::inner_product(origin,origin+3,vectorOriginal+3,0);
    originConverted[2] = std::inner_product(origin,origin+3,vectorOriginal+6,0);
    
    voxelSpacing[0] = [firstPix pixelSpacingX];
    voxelSpacing[1] = [firstPix pixelSpacingY];
    voxelSpacing[2] = [firstPix sliceInterval];
    
    //region.SetIndex(start);
    //region.SetSize(size);
    
    //importFilter->SetRegion(region);
    //importFilter->SetOrigin(originConverted);
    //importFilter->SetSpacing(voxelSpacing);
    //importFilter->SetImportPointer([viewerController volumePtr], bufferSize, false);
    
    //importFilterWrapper* wrapper = [[importFilterWrapper alloc] initWithViewerController: viewerController];
    //[wrapper getDataFromViewer];
    importFilter->setInputParameters (size, [viewerController volumePtr], voxelSpacing, originConverted, false);
    int lowerThreshold = -200;
    int upperThreshold = 300;
    
    BinaryThresholdImageFilterType::Pointer thresholdFilter = BinaryThresholdImageFilterType::New();
    thresholdFilter->SetInput (importFilter->GetOutput());
    //thresholdFilter->SetInput ([wrapper GetOutput]);
    thresholdFilter->SetLowerThreshold(lowerThreshold);
    thresholdFilter->SetUpperThreshold(upperThreshold);
    thresholdFilter->SetInsideValue(1000);
    thresholdFilter->SetOutsideValue(0);
    
    thresholdFilter->Update();
    
    float* resultBuff = thresholdFilter->GetOutput()->GetBufferPointer();
    
    //long mem = [wrapper GetSize] * sizeof(float);
    long mem = bufferSize * sizeof(float);
    memcpy ([viewerController volumePtr], resultBuff, mem);
    
    [viewerController needsDisplayUpdate];
    
    NSRunInformationalAlertPanel(@"Informacja", @"Zakonczono obrobke obrazu", @"OK", 0L, 0L);
    
   
    return 0;
    
}

@end
