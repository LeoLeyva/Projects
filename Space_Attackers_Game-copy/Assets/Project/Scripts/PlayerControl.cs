using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerControl : MonoBehaviour
{
    public float spd = 1.5f;
    public float hLimit = 2.5f;
    Rigidbody2D rb;
    public GameObject myMissle;
    bool shotPressed = false;
    public float missSpeed = 3;
    public float coolDuration = 1;
    float coolTimer;
    public ParticleSystem explode;


    // Start is called before the first frame update
    void Start()
    {
        rb = GetComponent<Rigidbody2D>();
    }


    // Update is called once per frame
    void FixedUpdate()
    {

        /**Just like the original game, the player can only move left and right.
         * Moreover, the player cannot go beyond the [hLimit] 
         * (right end of the screen) and -hLimit (left end of the screen). 
         * Attempting to do so would be equivalent to trying to walk through
         * a wall.*/

        rb.velocity = new Vector2(Input.GetAxis("Horizontal") *
            Time.deltaTime * spd, 0);
        if(transform.position.x  > hLimit)
        {
            transform.position = new Vector2(hLimit, transform.position.y);
            rb.velocity = new Vector2(0, 0);
        }
        else if (transform.position.x < -hLimit)
        {
            transform.position = new Vector2(-hLimit, transform.position.y);
            rb.velocity = new Vector2(0, 0);
        }


        /**In order to make the game interesting, the player is unable to 
         * spam missiles against the enemies. Instead, the player must wait 
         * through a [coolTimer] before being allowed to shoot another missile.
         * Moreover, if the missile does not collide with an enemy, it 
         * self-destructs after 5 seconds.*/


        coolTimer -= Time.deltaTime;
        if (Input.GetAxis("Fire1") > 0)
        {
            if (coolTimer <= 0 &&  !shotPressed)
            {
                coolTimer = coolDuration;
                shotPressed = true;
                GameObject missle = Instantiate(myMissle);
                missle.transform.SetParent(transform.parent);
                missle.transform.position = transform.position;
                missle.GetComponent<Rigidbody2D>().velocity =
                    new Vector2(0, missSpeed);
                Destroy(missle, 5);
            }

        }

        else
        {
            shotPressed = false;

        }

    }


    private void OnTriggerEnter2D(Collider2D collision)
    {

        /**If there is a collision between the player and the enemy's missile 
         * or the enemy itself, then all colliding objects will disappear and 
         * be replaced by the custom-made explosion. The explosion will then 
         * disappear after a few seconds.*/

        if (collision.CompareTag("EnemMissile") || collision.CompareTag("Enem"))
        {
            ParticleSystem myExplode = Instantiate(explode);
            myExplode.transform.SetParent(transform.parent);
            myExplode.transform.position = transform.position;
            Destroy(collision.gameObject);
            Destroy(this.gameObject);
            Destroy(myExplode, 2);
        }
    }
}
