     H dftactgrp(*no)                                   
     D len             c                   const(10)    
     D wwarr           s              4s 0 dim(*var:len)
     D i               s              2s 0              
       dsply %elem(wwarr);                              
       %elem(wwarr) = len;                              
       for i = 1 to len;                                
        wwarr(i) = i;                                   
       endfor;                                          
       dsply %elem(wwarr);                              
       return;                                          
