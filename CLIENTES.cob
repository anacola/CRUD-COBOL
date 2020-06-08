       IDENTIFICATION DIVISION.
       PROGRAM-ID. CLIENTES.
      ******************************************************************
      * Author:ANA CAROLINA COLA
      * Date:02/01/2020
      * Purpose: SISTEMA GESTAO DE CLIENTES
      * Tectonics: cobc
      ******************************************************************
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT CLIENTES ASSIGN
             TO 'C:\Users\anaco\Documents\Cobol\COBOL2\CLIENTES.DAT'
                   ORGANIZATION IS INDEXED
                   ACCESS MODE IS DYNAMIC
                   FILE STATUS IS CLIENTES-STATUS
                   RECORD KEY IS CLIENTES-CHAVE.

           SELECT RELATO ASSIGN
             TO 'C:\Users\anaco\Documents\Cobol\COBOL2\RELATO.TXT'
             ORGANIZATION IS SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
      **** ESTRUTURA PARA SE RELACIONAR COM O ARQUIVO DO FILE-CONTROL
       FD CLIENTES.
       01 CLIENTES-REG.
           05 CLIENTES-CHAVE.
               10 CLIENTES-FONE    PIC 9(09).
           05 CLIENTES-NOME        PIC X(30).
           05 CLIENTES-EMAIL       PIC X(40).

       FD RELATO.
       01 RELATO-REG.
           05 RELATO-DADOS PIC X(79).

       WORKING-STORAGE SECTION.
           77 WRK-OPCAO            PIC X(01).
           77 WRK-MODULO           PIC X(25).
           77 WRK-TECLA            PIC X(01).
           77 WRK-OPCAO-RELATO     PIC X(01).
           77 CLIENTES-STATUS      PIC 9(02).
           77 WRK-MSGERRO          PIC X(50).
           77 WRK-CONTALINHA       PIC 9(03) VALUE 0.
           77 WRK-QTREGISTROS      PIC 9(05).
           77 WRK-LINE             PIC 9(02) VALUE 06.
           77 WRK-VOLTAR           PIC X(01).

           01  ESC-CODE PIC 99 VALUE 0.
               88  ESC-KEY  VALUE 01.


       SCREEN SECTION.
       01 TELA.
           05 LIMPA-TELA.
               10 BLANK SCREEN.
               10 LINE 01 COLUMN 01 PIC X(20) ERASE EOL
                   BACKGROUND-COLOR 3.
               10 LINE 01 COLUMN 30 PIC X(20) BACKGROUND-COLOR 3
                   FOREGROUND-COLOR 0 FROM 'SISTEMA DE CLIENTES'.
               10 LINE 02 COLUMN 01 PIC X(25) ERASE EOL
                   BACKGROUND-COLOR 1.
               10 LINE 02 COLUMN 01 PIC X(25) ERASE EOL
                   BACKGROUND-COLOR 1 FROM WRK-MODULO.

       01 MENU.
           05 LINE 07 COLUMN 15 VALUE '1 - INCLUIR'.
           05 LINE 08 COLUMN 15 VALUE '2 - CONSULTAR'.
           05 LINE 09 COLUMN 15 VALUE '3 - ALTERAR'.
           05 LINE 10 COLUMN 15 VALUE '4 - EXCLUIR'.
           05 LINE 11 COLUMN 15 VALUE '5 - RELATORIO EM TELA'.
           05 LINE 12 COLUMN 15 VALUE '6 - RELATORIO EM DISCO'.
           05 LINE 13 COLUMN 15 VALUE 'x - SAIDA'.
           05 LINE 14 COLUMN 15 VALUE 'OPCAO...:'.
           05 LINE 14 COLUMN 28 USING WRK-OPCAO.

       01 RESULTADO-RELATORIO.
           05 DADOS.
               10 LINE WRK-LINE COLUMN 15 USING CLIENTES-FONE.
               10 COLUMN PLUS 2 USING CLIENTES-NOME.
               10 COLUMN PLUS 2 USING CLIENTES-EMAIL.

       01 TELA-REGISTRO.
           05 CHAVE FOREGROUND-COLOR 2.
               10 LINE 10 COLUMN 10 VALUE 'TELEFONE'.
               10 COLUMN PLUS 2 PIC 9(09) USING CLIENTES-FONE
                  BLANK WHEN ZEROS.
           05 SS-DADOS.
               10 LINE 11 COLUMN 10 VALUE 'NOME...'.
               10 COLUMN PLUS 2 PIC X(30) USING CLIENTES-NOME.
               10 LINE 12 COLUMN 10 VALUE 'EMAIL...'.
               10 COLUMN PLUS 2 PIC X(40) USING CLIENTES-EMAIL.

           05 SAIR-TELA.
               10 LINE 16 COLUMN 10 VALUE 'PARA SAIR APERTE F1'.

       01 MOSTRA-ERRO.
           02 MSG-ERRO.
               10 LINE 16 COLUMN 01 PIC X(20) ERASE EOL
                   BACKGROUND-COLOR 4.
               10 LINE 16 COLUMN 10 PIC X(40)
                   BACKGROUND-COLOR 4
                   FROM WRK-MSGERRO.
               10 COLUMN PLUS 2 PIC X(01)
                   BACKGROUND-COLOR 4
                   USING WRK-TECLA.


       PROCEDURE DIVISION.
       0001-PRINCIPAL SECTION.
           PERFORM 1000-INICIAR THRU 1100-MONTATELA.
           PERFORM 2000-PROCESSAR UNTIL WRK-OPCAO = 'X'
           PERFORM 3000-FINALIZAR.
           STOP RUN.

       1000-INICIAR.
           OPEN I-O CLIENTES
               IF CLIENTES-STATUS = 35 THEN
                   OPEN OUTPUT CLIENTES
                   CLOSE CLIENTES
                   OPEN I-O CLIENTES
               END-IF.

       1100-MONTATELA.
           DISPLAY TELA.
           ACCEPT MENU.

       2000-PROCESSAR.
           MOVE SPACES TO CLIENTES-NOME CLIENTES-EMAIL WRK-MSGERRO.
           EVALUATE WRK-OPCAO
               WHEN 1
                   PERFORM 5000-INCLUIR
               WHEN 2
                   PERFORM 6000-CONSULTAR
               WHEN 3
                   PERFORM 7000-ALTERAR
               WHEN 4
                   PERFORM 8000-EXCLUIR
               WHEN 5
                   PERFORM 9000-RELATORIOTELA
               WHEN 6
                   PERFORM 9100-RELATORIODISCO
               WHEN OTHER
                   IF WRK-OPCAO NOT EQUAL 'X'
                       DISPLAY 'ENTRADA ERRADA'
                   END-IF
           END-EVALUATE.
               PERFORM 1100-MONTATELA.

       3000-FINALIZAR.
           CLOSE CLIENTES.

       5000-INCLUIR.
           MOVE 'MODULO - INCLUSAO' TO WRK-MODULO.
           DISPLAY TELA.
           MOVE ZEROS TO CLIENTES-CHAVE.
           ACCEPT TELA-REGISTRO.
               WRITE CLIENTES-REG
                INVALID KEY
                 MOVE 'JA EXISTE! (N)OVO REGISTRO?' TO WRK-MSGERRO
                 ACCEPT MOSTRA-ERRO
                 IF WRK-TECLA = 'N' OR WRK-TECLA = 'n'
                     MOVE ZEROS TO CLIENTES-FONE
                    PERFORM 5000-INCLUIR
                  END-IF
                END-WRITE.

                ACCEPT ESC-CODE FROM ESCAPE KEY
                IF ESC-KEY
                   PERFORM 1100-MONTATELA
                END-IF.

       6000-CONSULTAR.
           MOVE 'MODULO - CONSULTAR' TO WRK-MODULO.
           DISPLAY TELA.
               DISPLAY TELA-REGISTRO.
               MOVE ZEROS TO CLIENTES-CHAVE.
                  ACCEPT CHAVE.
                   READ CLIENTES
                    INVALID KEY
                       MOVE '---NAO ENCONTRADO---' TO WRK-MSGERRO
                    NOT INVALID KEY
                       MOVE'--- ENCONTRADO ---' TO WRK-MSGERRO
                       DISPLAY SS-DADOS
                   END-READ.
                   ACCEPT MOSTRA-ERRO.

       7000-ALTERAR.
           MOVE 'MODULO - CONSULTAR' TO WRK-MODULO.
           DISPLAY TELA.
               DISPLAY TELA-REGISTRO.
               MOVE ZEROS TO CLIENTES-CHAVE.
               ACCEPT CHAVE.
                READ CLIENTES
                   IF CLIENTES-STATUS = 0
                    ACCEPT SS-DADOS
                     REWRITE CLIENTES-REG
                      IF CLIENTES-STATUS = 0
                       MOVE 'REGISTRO ALTERADO ' TO WRK-MSGERRO
                       ACCEPT MOSTRA-ERRO
                      ELSE
                       MOVE 'REGISTRO NAO ALTERADO' TO WRK-MSGERRO
                       ACCEPT MOSTRA-ERRO
                      END-IF
                   ELSE
                       MOVE 'REGISTRO NAO ENCONTRADO' TO WRK-MSGERRO
                       ACCEPT MOSTRA-ERRO
                   END-IF.

       8000-EXCLUIR.
           MOVE 'MODULO - EXCLUIR' TO WRK-MODULO.
           DISPLAY TELA.
            DISPLAY TELA-REGISTRO.
            MOVE ZEROS TO CLIENTES-CHAVE.
               ACCEPT CHAVE.
                READ CLIENTES
                 INVALID KEY
                  MOVE '---NAO ENCONTRADO---' TO WRK-MSGERRO
                 NOT INVALID KEY
                  MOVE'--- EXCLUIR (S/N) ? ---' TO WRK-MSGERRO
                  DISPLAY SS-DADOS
                END-READ.
                    ACCEPT MOSTRA-ERRO.
                    IF WRK-TECLA = 'S' AND CLIENTES-STATUS = 0
                        DELETE CLIENTES
                       INVALID KEY
                       MOVE 'NAO EXCLUIDO' TO WRK-MSGERRO
                       ACCEPT MOSTRA-ERRO
                       END-DELETE
                    END-IF.

                   ACCEPT ESC-CODE FROM ESCAPE KEY
                   PERFORM 1100-MONTATELA.

       9000-RELATORIOTELA.
           MOVE 'MODULO - RELATORIO ' TO WRK-MODULO.
             DISPLAY TELA.
             MOVE 123456789 TO CLIENTES-FONE.
             START CLIENTES KEY EQUAL CLIENTES-FONE.
             READ CLIENTES
                 INVALID KEY
                     MOVE 'NENHUM REGISTRO ENCONTRADO' TO WRK-MSGERRO
                  NOT INVALID KEY
                  DISPLAY 'RELATORIO' AT 0301
                  DISPLAY '----------------------' AT 0401
                    PERFORM UNTIL CLIENTES-STATUS = 10
                     ADD 1 TO WRK-QTREGISTROS
                     DISPLAY RESULTADO-RELATORIO
                       ADD 1 TO WRK-LINE
                       READ CLIENTES NEXT
                     ADD 1 TO WRK-CONTALINHA
                     IF WRK-CONTALINHA = 5
                         MOVE 'PRESSIONE ALGUMA TECLA ' TO WRK-MSGERRO
                         ACCEPT MOSTRA-ERRO
                        MOVE 'MODULO - RELATORIO ' TO WRK-MODULO
                        DISPLAY TELA
                        MOVE 'RELATORIO CONCLUIDO' TO WRK-MSGERRO
                        DISPLAY 'RELATORIO' AT 0301
                        DISPLAY '----------------------' AT 0401
                        MOVE 0 TO WRK-CONTALINHA
                     END-IF
                   END-PERFORM
             END-READ.
               MOVE 'REGISTROS LIDOS ' TO WRK-MSGERRO.
               MOVE WRK-QTREGISTROS TO WRK-MSGERRO(17:05).
               ACCEPT MOSTRA-ERRO.

       9100-RELATORIODISCO.
           MOVE 'MODULO - RELATORIO ' TO WRK-MODULO.
             DISPLAY TELA.
             MOVE 123456789 TO CLIENTES-FONE.
             START CLIENTES KEY EQUAL CLIENTES-FONE.
             READ CLIENTES
                 INVALID KEY
                     MOVE 'NENHUM REGISTRO ENCONTRADO' TO WRK-MSGERRO
                  NOT INVALID KEY
                  OPEN OUTPUT RELATO
                   PERFORM UNTIL CLIENTES-STATUS = 10
                     ADD 1 TO WRK-QTREGISTROS
                       MOVE CLIENTES-REG TO RELATO-REG
                       WRITE RELATO-REG
                     READ CLIENTES NEXT
                   END-PERFORM
                     MOVE 'REGISTROS LIDOS ' TO RELATO-REG
                     MOVE WRK-QTREGISTROS    TO RELATO-REG(18:05)
                     WRITE RELATO-REG
                     CLOSE RELATO
             END-READ.
               MOVE 'REGISTROS LIDOS ' TO WRK-MSGERRO.
               MOVE WRK-QTREGISTROS TO WRK-MSGERRO(17:05).
               ACCEPT MOSTRA-ERRO.
