#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "econio.h"
void rota(short forg[3][3], short hol[2][2][2]){
	/*Felso harmad forgatoja.*/
	int csere;
	/*Tengelykocka forgatasa:*/
	if (forg[0][1])
		forg[0][1]=0;
	else
		forg[0][1]=1;
	/*Szelso kockak forgatasa csere kozben:*/
	csere=forg[0][0];
	if (forg[0][2])
		forg[0][0]=0;
	else
		forg[0][0]=1;
	if (csere)
		forg[0][2]=0;
	else
		forg[0][2]=1;
	/*Szelso kockak fuggoleges koordinatainak csereje:*/
	csere=hol[0][0][0];
	hol[0][0][0]=hol[0][1][0];
	hol[0][1][0]=csere;
	/*Szelso kockak vizszintes koordinatainak csereje:*/
	csere=hol[0][0][1];
	if (hol[0][1][1])
		hol[0][0][1]=0;
	else
		hol[0][0][1]=1;
	if (csere)
		hol[0][1][1]=0;
	else
		hol[0][1][1]=1;
}
void rotb(short forg[3][3], short hol[2][2][2]) {
	/*Jobb harmad forgatoja*/
	int csere;
	/*Tengelykocka forgatasa:*/
	if (forg[1][2])
		forg[1][2]=0;
	else
		forg[1][2]=1;
	/*Szelso kockak forgatasa csere kozben:*/
	csere=forg[0][2];
	if (forg[2][2])
		forg[0][2]=0;
	else
		forg[0][2]=1;
	if (csere)
		forg[2][2]=0;
	else
		forg[2][2]=1;
	/*Szelso kockak vizszintes koordinatainak csereje:*/
	csere=hol[0][1][1];
	hol[0][1][1]=hol[1][1][1];
	hol[1][1][1]=csere;
	/*Szelso kockak fuggoleges koordinatainak csereje:*/
	csere=hol[0][1][0];
	if (hol[1][1][0])
		hol[0][1][0]=0;
	else
		hol[0][1][0]=1;
	if (csere)
		hol[1][1][0]=0;
	else
		hol[1][1][0]=1;
}
void rotc(short forg[3][3], short hol[2][2][2]) {
	/*Also harmad forgatoja.*/
	int csere;
	/*Tengelykocka forgatasa:*/
	if (forg[2][1])
		forg[2][1]=0;
	else
		forg[2][1]=1;
	/*Szelso kockak forgatasa csere kozben:*/
	csere=forg[2][0];
	if (forg[2][2])
		forg[2][0]=0;
	else
		forg[2][0]=1;
	if (csere)
		forg[2][2]=0;
	else
		forg[2][2]=1;
	/*Szelso kockak fuggoleges koordinatainak csereje:*/
	csere=hol[1][0][0];
	hol[1][0][0]=hol[1][1][0];
	hol[1][1][0]=csere;
	/*Szelso kockak vizszintes koordinatainak csereje:*/
	csere=hol[1][0][1];
	if (hol[1][1][1])
		hol[1][0][1]=0;
	else
		hol[1][0][1]=1;
	if (csere)
		hol[1][1][1]=0;
	else
		hol[1][1][1]=1;
}
void rotd(short forg[3][3], short hol[2][2][2]) {
	/*Bal harmad forgatoja.*/
	int csere;
	/*Tengelykocka forgatasa:*/
	if (forg[1][0])
		forg[1][0]=0;
	else
		forg[1][0]=1;
	/*Szelso kockak forgatasa csere kozben:*/
	csere=forg[0][0];
	if (forg[2][0])
		forg[0][0]=0;
	else
		forg[0][0]=1;
	if (csere)
		forg[2][0]=0;
	else
		forg[2][0]=1;
	/*Szelso kockak vizszintes koordinatainak csereje:*/
	csere=hol[0][0][1];
	hol[0][0][1]=hol[1][0][1];
	hol[1][0][1]=csere;
	/*Szelso kockak fuggoleges koordinatainak csereje:*/
	csere=hol[0][0][0];
	if (hol[1][0][0])
		hol[0][0][0]=0;
	else
		hol[0][0][0]=1;
	if (csere)
		hol[1][0][0]=0;
	else
		hol[1][0][0]=1;
}
void kiir (short forg[3][3], short hol[2][2][2]){
	/*Matrixkiiro.*/
	int i, j, k;
	/*Forgatottsagi jelzoszamok:*/
	for (i=0; i<3; i++) {
		for (j=0; j<3; j++) {
			putchar(forg[i][j]+48);
			putchar(' ');
		}
		putchar('\n');
	}
	/*Eltolasi jelzoszamok:*/
	for (i=0; i<2; i++) {
		for (j=0; j<2; j++) {
			for (k=0; k<2; k++)
				putchar(hol[i][j][k]+48);
			putchar(' ');
		}
		putchar('\n');
	}
}
int ment (short forg[3][3], short hol[2][2][2]){
	/*Matrixtarolo. Hiba eseten visszateresi erteke 1.*/
	FILE *save=NULL;
	int i, j, k, hiba=0;
	save=fopen ("c:/Users/Danci/Documents/BME/Programozás/Kocka/Mentes.txt", "wt");
	if (save) {
		/*Forgatottsagi jelzoszamok:*/
		for (i=0; i<3; i++) {
			for (j=0; j<3; j++) {
				putc(forg[i][j]+48, save);
				putc(' ', save);
			}
			if (putc('\n', save)==EOF) {
				hiba=1;
				break;
			}
		}
		/*Eltolasi jelzoszamok:*/
		for (i=0; i<2; i++) {
			if (hiba)
				break;
			for (j=0; j<2; j++) {
				for (k=0; k<2; k++)
					putc(hol[i][j][k]+48, save);
				putc(' ', save);
			}
			if (putc('\n', save)==EOF)
				hiba=1;
		}
		fclose (save);
		save=NULL;
	}
	else
		hiba=1;
	return hiba;
}
void indit (short forg[3][3], short hol[2][2][2]){
	/*Tombinicializator.*/
	int i, j, k;
	/*Forgatasi jelzoszamok nullazasa:*/
	for (i=0; i<3; i++)
		for (j=0; j<3; j++)
			forg[i][j]=0;
	/*Eltolasi jelzoszamok nullazasa:*/
	for (i=0; i<2; i++)
		for (j=0; j<2; j++)
			for (k=0; k<2; k++)
				hol[i][j][k]=0;
}
int betolt (short forg[3][3], short hol[2][2][2]) {
	/*Matrixbetolto fv. Hiba eseten visszateresi erteke 1.*/
	FILE *load=NULL;
	int i, j, k, hiba=0;
	short sforg[3][3], shol[2][2][2];
	load=fopen("c:/Users/Danci/Documents/BME/Programozás/Kocka/Mentes.txt", "rt");
	if (load) {
		/*Forgatottsagi jelzoszamok ideiglenes betoltese:*/
		for (i=0; i<3; i++) {
			if (hiba)
				break;
			for (j=0; j<3; j++) {
				if (hiba)
					break;
				sforg[i][j]=getc(load)-48;
				if (sforg[i][j]!=0 && sforg[i][j]!=1)
					hiba=1;
				getc(load);
			}
			getc(load);
		}
		/*Eltolasi jelzoszamok ideiglenes betoltese:*/
		for (i=0; i<2; i++) {
			if (hiba)
				break;
			for (j=0; j<2; j++) {
				if (hiba)
					break;
				for (k=0; k<2; k++) {
					if (hiba)
						break;
					shol[i][j][k]=getc(load)-48;
					if (shol[i][j][k]!=0 && shol[i][j][k]!=1)
						hiba=1;
				}
				getc(load);
			}
			getc(load);
		}
		fclose (load);
		load=NULL;
	}
	else
		hiba=1;
	if (hiba)
		return 1;
	/*Betoltes veglegesitese:*/
	for (i=0; i<3; i++)
		for (j=0; j<3; j++)
			forg[i][j]=sforg[i][j];
	for (i=0; i<2; i++)
		for (j=0; j<2; j++)
			for (k=0; k<2; k++)
				hol[i][j][k]=shol[i][j][k];
	return 0;
}
void kever(short forg[3][3], short hol[2][2][2]) {
	/*Keverofuggveny.*/
	int szam=-1, i, ker=1, elo=0;
	srand(time(0));
	/*Szamkeres:*/
	printf("Hany lepesben keverjem ossze?\n0: megse\n");
	while (ker) {
		i=0;
		scanf("%d", &szam);
		while (i!=10)
			i=getchar();
		/*A bizonytalan user kedveert:*/
		if (szam==0)
			return;
		/*A hulye user kedveert:*/
		if (szam<0)
			printf("Egy nemnegativ szamot kerek!\n");
		else
			ker=0;
	}
	/*A keveres:*/
	for (i=0; i<szam; i++) {
		while (ker==elo)
			ker=rand()%4;
		switch (ker) {
			case 0:
				rota(forg, hol);
			break;
			case 1:
				rotb(forg, hol);
			break;
			case 2:
				rotc(forg, hol);
			break;
			case 3:
				rotd(forg, hol);
			break;
		}
		elo=ker;
	}
}
int main() {
	printf("Matrixkocka 3*3*1\nVerzio: 1.5\nKeszitette:Koics Dani\n");
	int kar, fut=1;
	short forg[3][3];
	short hol[2][2][2];
	indit(forg, hol);
	printf ("Cel: a kovetkezo szamhalmaz visszaallitasa:\n");
	kiir(forg, hol);
	while (fut){
		kar=10;
		printf("f: felso\na: also\nj: jobb\nb: bal\nk: osszekever\nu:ujraindit\nm: tarol\nt: betolt\nv: kilep\n");
		while(kar==10)
			kar=getchar();
		switch (kar) {
			case 'f':
				rota(forg, hol);
			break;
			case 'a':
				rotc(forg, hol);
			break;
			case 'j':
				rotb(forg, hol);
			break;
			case 'b':
				rotd(forg, hol);
			break;
			case 'k':
				kever(forg, hol);
			break;
			case 'u':
				indit(forg, hol);
			break;
			case 'm':
				if (ment(forg, hol))
					printf ("A mentes sikertelen!\n");
				else
					printf ("A mentes sikeres!\n");
			break;
			case 't':
				if (betolt(forg, hol))
					printf("Nincs betoltheto jatek.\n");
				else
					printf("A jatek betoltve.\n");
			break;
			case 'v':
				fut=0;
			break;
			default:
				printf("Ervenytelen billentyu.");
			break;
		}
		if (fut)
			kiir(forg, hol);
	}
	return 0;
}
