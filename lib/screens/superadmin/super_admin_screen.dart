import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';


class SuperAdminScreen extends StatelessWidget {
  const SuperAdminScreen({super.key});


  // =====================================================
  // ALTERAR ROLE
  // =====================================================

  Future<void> setRole(
    BuildContext context,
    String uid,
    String role,
  ) async {

    try {

      await FirebaseFirestore.instance
          .collection("usuarios")
          .doc(uid)
          .update({
        "role": role,
      });


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Permissão alterada para $role",
          ),
        ),
      );


    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Erro: $e",
          ),
        ),
      );

    }

  }




  // =====================================================
  // ALTERAR STATUS
  // =====================================================

  Future<void> setStatus(
    BuildContext context,
    String uid,
    String status,
  ) async {


    try {


      await FirebaseFirestore.instance
          .collection("usuarios")
          .doc(uid)
          .update({

        "status": status,

      });



      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.blue,
          content: Text(
            "Status alterado para $status",
          ),
        ),
      );


    } catch(e){

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Erro: $e",
          ),
        ),
      );

    }

  }





  // =====================================================
  // LOGOUT
  // =====================================================

  Future<void> logout(BuildContext context) async {


    final confirmar =
        await showDialog<bool>(
      context: context,

      builder: (context){

        return AlertDialog(

          title:
              const Text(
            "Sair do painel?",
          ),


          content:
              const Text(
            "Deseja realmente sair da conta Super Admin?",
          ),


          actions:[


            TextButton(

              onPressed: (){
                Navigator.pop(
                  context,
                  false,
                );
              },

              child:
                  const Text(
                "Cancelar",
              ),

            ),



            ElevatedButton(

              onPressed: (){
                Navigator.pop(
                  context,
                  true,
                );
              },

              child:
                  const Text(
                "Sair",
              ),

            ),


          ],

        );

      },
    );



    if(confirmar != true) return;



    await context
        .read<AuthProvider>()
        .logout();


  }





  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor:
          const Color(0xffF1F5F9),



      appBar: AppBar(


        elevation: 0,


        centerTitle:true,


        title:
            const Text(
          "Super Admin",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),



        flexibleSpace:
            Container(

          decoration:
              const BoxDecoration(

            gradient:
                LinearGradient(

              colors:[

                Color(0xff111827),

                Color(0xff2563EB),

              ],

            ),

          ),

        ),



        actions:[


          IconButton(

            tooltip:"Logout",

            icon:
                const Icon(
              Icons.logout,
            ),


            onPressed:(){

              logout(context);

            },


          )


        ],


      ),






      body:


      StreamBuilder<QuerySnapshot>(


        stream:
            FirebaseFirestore.instance
                .collection("usuarios")
                .snapshots(),



        builder:
            (context,snapshot){



          if(snapshot.connectionState ==
              ConnectionState.waiting){


            return const Center(

              child:
                  CircularProgressIndicator(),

            );

          }




          if(snapshot.hasError){


            return Center(

              child:
                  Text(
                "Erro:\n${snapshot.error}",
                textAlign:
                    TextAlign.center,
              ),

            );


          }




          final usuarios =
              snapshot.data!.docs;



          if(usuarios.isEmpty){


            return const Center(

              child:
                  Text(
                "Nenhum usuário cadastrado",
              ),

            );

          }





          return ListView.builder(


            padding:
                const EdgeInsets.all(16),



            itemCount:
                usuarios.length,



            itemBuilder:
                (context,index){



              final doc =
                  usuarios[index];



              final data =
                  doc.data()
                      as Map<String,dynamic>;



              final uid =
                  doc.id;



              final nome =
                  data["nome"] ??
                  "Sem nome";



              final email =
                  data["email"] ??
                  "";



              final role =
                  data["role"] ??
                  "aluno";



              final status =
                  data["status"] ??
                  "ATIVO";



              final ativo =
                  status
                      .toString()
                      .toUpperCase()
                      ==
                      "ATIVO";





              return Card(


                elevation:4,


                margin:
                    const EdgeInsets.only(
                  bottom:18,
                ),



                shape:
                    RoundedRectangleBorder(

                  borderRadius:
                      BorderRadius.circular(20),

                ),




                child:
                    Padding(

                  padding:
                      const EdgeInsets.all(18),



                  child:
                      Column(

                    crossAxisAlignment:
                        CrossAxisAlignment.start,


                    children:[




                      Row(

                        children:[



                          CircleAvatar(

                            radius:28,


                            backgroundColor:
                                Colors.blue.shade100,


                            child:
                                Text(

                              nome
                                  .toString()
                                  .substring(0,1)
                                  .toUpperCase(),

                              style:
                                  const TextStyle(

                                fontSize:22,

                                fontWeight:
                                    FontWeight.bold,

                              ),

                            ),

                          ),



                          const SizedBox(
                            width:15,
                          ),



                          Expanded(

                            child:
                                Column(

                              crossAxisAlignment:
                                  CrossAxisAlignment.start,


                              children:[

                                Text(

                                  nome,

                                  style:
                                      const TextStyle(

                                    fontSize:18,

                                    fontWeight:
                                        FontWeight.bold,

                                  ),

                                ),


                                Text(
                                  email,
                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.grey,
                                  ),
                                ),


                              ],

                            ),

                          )

                        ],

                      ),




                      const SizedBox(
                        height:15,
                      ),




                      Wrap(

                        spacing:8,


                        children:[


                          Chip(

                            label:
                                Text(
                              role.toUpperCase(),
                            ),


                            avatar:
                                const Icon(
                              Icons.security,
                              size:18,
                            ),

                          ),




                          Chip(

                            label:
                                Text(status),


                            backgroundColor:
                                ativo
                                    ? Colors.green.shade100
                                    : Colors.red.shade100,


                          ),


                        ],

                      ),





                      const SizedBox(
                        height:15,
                      ),





                      Wrap(

                        spacing:8,


                        children:[


                          ElevatedButton.icon(

                            onPressed:(){

                              setStatus(
                                context,
                                uid,
                                "ATIVO",
                              );

                            },


                            icon:
                                const Icon(
                              Icons.check,
                            ),


                            label:
                                const Text(
                              "Ativar",
                            ),

                          ),




                          OutlinedButton.icon(

                            onPressed:(){

                              setStatus(
                                context,
                                uid,
                                "INATIVO",
                              );

                            },


                            icon:
                                const Icon(
                              Icons.block,
                            ),


                            label:
                                const Text(
                              "Bloquear",
                            ),

                          ),




                          PopupMenuButton<String>(


                            onSelected:(value){

                              setRole(
                                context,
                                uid,
                                value,
                              );

                            },


                            itemBuilder:(context)=>[


                              const PopupMenuItem(
                                value:"aluno",
                                child:
                                    Text(
                                  "Aluno",
                                ),
                              ),


                              const PopupMenuItem(
                                value:"admin",
                                child:
                                    Text(
                                  "Admin",
                                ),
                              ),


                              const PopupMenuItem(
                                value:"superadmin",
                                child:
                                    Text(
                                  "Super Admin",
                                ),
                              ),


                            ],


                            child:
                                const Chip(

                              label:
                                  Text(
                                "Alterar Role",
                              ),

                              avatar:
                                  Icon(
                                Icons.edit,
                              ),

                            ),

                          )



                        ],

                      ),




                      const SizedBox(
                        height:10,
                      ),




                      Text(

                        "UID: $uid",

                        style:
                            const TextStyle(

                          fontSize:11,

                          color:
                              Colors.grey,

                        ),

                      ),



                    ],

                  ),

                ),


              );


            },

          );



        },


      ),


    );

  }

}