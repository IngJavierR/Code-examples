     H dftactgrp(*no)                           
     Dfactorial        pr            10s 0      
     D                                1s 0 value
     D*                                         
     D wwres           s             10s 0      
     C*                                         
       wwres = factorial(4);                    
       dsply wwres;                             
       return;                                  
     P*                                         
     Pfactorial        b                        
     D                 pi            10s 0      
     D n                              1s 0 value
     C*                           
       if (n = 0);                
        return 1;                 
       else;                      
        return n * factorial(n-1);
       endif;                     
     p                 e          

