using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CarController : MonoBehaviour
{
    private Rigidbody getcomp;
   [SerializeField] private float speed;

   private float Forward;

   private float Horchange;
    // Start is called before the first frame update
    void Start()
    {
        getcomp = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {

        Horchange += Input.GetAxis("Horizontal")*0.005f;
        Forward  = Input.GetAxis("Vertical");

      

    }


    private void FixedUpdate()
    {

        Vector3 truler = transform.eulerAngles;
        transform.rotation =
            Quaternion.LookRotation(new Vector3(transform.forward.x+Mathf.Cos(Horchange), 0, transform.forward.z-Mathf.Sin(Horchange)), transform.up);
        Vector3 nuvec = new Vector3((Forward * speed * transform.up).x, getcomp.velocity.y,(Forward * speed * transform.up).z );

       
        
        getcomp.velocity = nuvec;



    }
}
