function [new]=track(seq1,seq2,t_table)
     r=length(seq2);
     c=length(seq1);
     newseq1='';
     newseq2='';
     while r~=0|c~=0
        v=t_table(r,c);
        if v==1
            newseq1=[seq1(c) newseq1];
            newseq2=[seq2(r) newseq2];
            r=r-1;
            c=c-1;
        end
        if v==2
            newseq2=[seq2(r) newseq2];
            newseq1=['-' newseq1];
            r=r-1;
        end
        if v==3
           newseq1=[seq1(c) newseq1]; 
           newseq2=['-' newseq2];
           c=c-1;
        end
        %% if touch the boundary
        if r==0
            newseq1=[seq1(1:c) newseq1];
            newseq2=[char(ones(1,c)*45) newseq2];
            break;
        end
        if c==0
           newseq2=[seq2(1:r) newseq2];
            newseq1=[char(ones(1,r)*45) newseq1];
            break;
        end   
     end
     new=[newseq1;newseq2];
end
