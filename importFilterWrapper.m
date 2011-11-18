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
-(importFilterWrapper*) initWithViewerController: (ViewerController*) vc
{
    if ((self = [super init])) {
        viewerController = vc;
        totalSize = 0;
        importFilter  = bartImportFilter<myPixelType, 3>::New();
        [self getDataFromViewer];
        return self;
    }
    else    {
        //TODO: obsluga bledu
        return 0;
    }
            

}

-(long) GetSize
{
    return totalSize;
}
-(void) getDataFromViewer
{
    

    DCMPix  *firstPix =[ [viewerController pixList] objectAtIndex:0 ];
    int slices = [[viewerController pixList] count];
    
    int size [3];
    size[0] = [firstPix pwidth];
    size[1] = [firstPix pheight];
    size[2] = slices;
  
    totalSize = size[0]*size[1]*size[2];
    
    float origin[3];
    float originConverted [3];
    double vectorOriginal [9];
    float voxelSpacing [3];
    
    origin[0] = [firstPix originX];
    origin[1] = [firstPix originY];
    origin[2] = [firstPix originZ];
    
    [firstPix orientationDouble: vectorOriginal];
    originConverted[0] = origin[0]*vectorOriginal[0] + origin[1]*vectorOriginal[1] + origin[2]*vectorOriginal[2];
    originConverted[1] = origin[0]*vectorOriginal[3] + origin[1]*vectorOriginal[4] + origin[2]*vectorOriginal[5]; 
    originConverted[2] = origin[0]*vectorOriginal[6] + origin[1]*vectorOriginal[7] + origin[2]*vectorOriginal[8];
    //originConverted[0] = std::inner_product(origin,origin+3,vectorOriginal,0);
    //originConverted[1] = std::inner_product(origin,origin+3,vectorOriginal+3,0);
    //originConverted[2] = std::inner_product(origin,origin+3,vectorOriginal+6,0);
    
    voxelSpacing[0] = [firstPix pixelSpacingX];
    voxelSpacing[1] = [firstPix pixelSpacingY];
    voxelSpacing[2] = [firstPix sliceInterval];

    importFilter->setInputParameters (size, [viewerController volumePtr], voxelSpacing, originConverted, false);
                                      
                                      
    
}
-(itk::Image<float,3>*) GetOutput
{
    return importFilter->GetOutput();
}
@end
