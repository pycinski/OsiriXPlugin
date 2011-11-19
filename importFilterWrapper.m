//
//  importFilterWrapper.m
//  bart4
//
//  Created by Bartlomiej Pycinski on 11-11-11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "importFilterWrapper.h"
#import "OsiriXAPI/DCMPix.h"
#import "OsiriXAPI/ViewerController.h"
#include "bartImportFilter.h"

@implementation importFilterWrapper

   //TODO destruktor


-(int*) GetSize
{
    return size;
}
-(void)GetViewerParameters
{
    
    NSArray *pixList = [viewerController pixList];
    DCMPix  *firstPix =[ pixList objectAtIndex:0 ];
    int slices = [pixList count];
    
    
    size[0] = [firstPix pwidth];
    size[1] = [firstPix pheight];
    size[2] = slices;
  
    float origin[3];
    float originConverted [3];
    float vectorOriginal [9];
    float voxelSpacing [3];
    
    origin[0] = [firstPix originX];
    origin[1] = [firstPix originY];
    origin[2] = [firstPix originZ];
    
    [firstPix orientation: vectorOriginal];  //podstawia pod vectorOriginal parametry orientation
    //TODO sprawdzic w debugerze jakie sa rzeczywiste wartosci w tym vectorOriginal
    originConverted[0] = origin[0]*vectorOriginal[0] + origin[1]*vectorOriginal[1] + origin[2]*vectorOriginal[2];
    originConverted[1] = origin[0]*vectorOriginal[3] + origin[1]*vectorOriginal[4] + origin[2]*vectorOriginal[5]; 
    originConverted[2] = origin[0]*vectorOriginal[6] + origin[1]*vectorOriginal[7] + origin[2]*vectorOriginal[8];
    //originConverted[0] = std::inner_product(origin,origin+3,vectorOriginal,0);
    //originConverted[1] = std::inner_product(origin,origin+3,vectorOriginal+3,0);
    //originConverted[2] = std::inner_product(origin,origin+3,vectorOriginal+6,0);
    
    voxelSpacing[0] = [firstPix pixelSpacingX];
    voxelSpacing[1] = [firstPix pixelSpacingY];
    //TODO sprawdzic w debugerze ponizsze wartosci
    voxelSpacing[2] = [firstPix sliceInterval] || [firstPix sliceThickness]; //if (sliceInterval==0) then sliceThickness

    importFilter->setInputParameters (size, [viewerController volumePtr], voxelSpacing, originConverted, false);
                                      
}

-(importFilterWrapper*) initWithViewerController: (ViewerController*) vc
{
    if ((self = [super init])) {
        viewerController = vc;
        size[0] = size[1] = size[2] = 0;
        importFilter  = bartImportFilter<myPixelType, 3>::New();
        [self GetViewerParameters];
        return self;
    }
    else    {
        //TODO: obsluga bledu
        return 0;
    }


}

- (void)DisplayImage:(itk::Image<float,3> *)lastFilterOutput {

    float* resultBuff = lastFilterOutput->GetBufferPointer();
    //ponizszy wiersz to iloczyn sizeof(float)*size[0]*size[1]*size[2]
    //int bufferSize = std::accumulate(size, size+3, sizeof(float), std::multiplies<int>());
    int bufferSize = sizeof(float)*size[0]*size[1]*size[2];
    memcpy ([viewerController volumePtr], resultBuff, bufferSize);
    [viewerController needsDisplayUpdate];
}

-(void) Update {
    importFilter->Update();
}

//TODO chyba inny typ zwracany ?
-(itk::Image<float,3>*) GetOutput
{
    return importFilter->GetOutput();
}
@end
