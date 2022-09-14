#Création de deux listes qui contiennent les indices des résidus impliqués dans la liaison hydrogène
HDonor = []
HAcceptor = []
with open("new_1ubq.hb2", "r") as HB :
        for line in HB:
            if line.startswith('A00'):
                HDonor_num = int (line [3:5])
                HAcceptor_num = int (line [17:19])
                HDonor.append(HDonor_num)
                HAcceptor.append(HAcceptor_num)
print (HDonor)
print (HAcceptor)

#Fonction turn: seulement turn_4 parce qu'on s'intéresse aux hélices alpha
turn =[]
i = 0
x = 0   
for i in range(len(HDonor)):
            x=abs(HDonor[i]-HAcceptor[i])
            if x == 4 :
               turn.append([HDonor[i],HAcceptor[i]])
print("turn" , turn)

#Détermination d'Hélice
turn_H = []
for i in range(len(turn)-1):
    if abs(turn[i][0] - turn[i+1][0]) == 1:
        turn_H.append(turn[i])
#print("turn_H : " , turn_H)
print ("laison d'une Hélice alpha :" , turn[i])


for i in range(len(HDonor)) :
    if (HDonor[i],HAcceptor[i]) in turn_H :
        print("H" , end="")
    else :
        print("-" , end="" )
print ("/n")
# Pour avoir une liste qui permet de former les couples ( donneur , accepteur) impliqués dans la liaison d'hydrogène
h_Bond = []
for i in range (len(HDonor)):
    h_Bond.append([HDonor[i],HAcceptor[i]])
print ( "h_Bond: {}".format(h_Bond) )

#On enlève les couples qui sont impliqués dans les laisons de la formation des Hélices
h_Bond_F = []
for i in range (len(h_Bond)) :
    if h_Bond[i] not in turn_H :
        h_Bond_F.append(h_Bond[i])
print ("h_Bond_F:", h_Bond_F)

# Trier la liste des donneurs et accepteurs dans un ordre croissant
h_Bond_sort = sorted(h_Bond_F)
print("h_Bond_sort :", h_Bond_sort)

#Permet de crier des listes où les donneurs sont consécutifs
h_cons = []
for i in range (1,len(h_Bond_F)-1) :
        if h_Bond_sort[i+1][0]- h_Bond_sort[i][0] == 1 and h_Bond_sort[i][0]- h_Bond_sort[i-1][0] == 1 :
            h_cons.append([h_Bond_sort[i-1], h_Bond_sort[i] , h_Bond_sort[i+1] ])
print ("h_cons : " ,h_cons)



#Permet de vérifier la position des accepteurs l'un par rapports à son consécutifs pour créer des listes de bridge : parallèle et antiparallèle
#Bridges parallèles et Antiparallèles
brid_P = []
brid_Anti = []
for i in range (len(h_cons)-2) :
    if h_cons[i][0][1] - h_cons[i][2][1] == -2 : 
      brid_P.append (h_cons[i])
      brid_P.append (h_cons[i+1]) 
    else :
         if h_cons[i][0][1] -  h_cons[i][2][1] == 2 :
            brid_Anti.append([h_cons[i],h_cons[i+1]])
print ("brid_P :" , brid_P )
print ("brid_Anti :" , brid_Anti )   
   

#Détermination des ladders à partir des listes de Bridge
ladd_P = []
for i in range(len(brid_P)-1):
    if abs(brid_P[i][0][0] - brid_P[i+1][0][0]) == 1:
        ladd_P.append(brid_P[i])
print("ladd_P : " , ladd_P)

ladd_Anti = []
for i in range(len(brid_Anti)-1):
    if abs(brid_Anti[i][0][0] - brid_Anti[i+1][0][0]) == 1:
        ladd_Anti.append(brid_P[i])
print("ladd_Anti : " , ladd_Anti)
ladder = ladd_P + ladd_Anti
#Détermination des feuillets beta
feuillet=[]
for i in range (len(ladder)) :
    if ladder[i][0] or ladder[i][1] or ladder[i][2] in ladder[i+1] :
        feuillet.append(ladder[i])
print("feuillet", feuillet)
    
