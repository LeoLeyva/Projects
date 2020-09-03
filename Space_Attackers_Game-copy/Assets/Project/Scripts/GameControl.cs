using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameControl : MonoBehaviour
{

    public float shootInterval = 3f;
    float shootTimer;
    public float shootSpd = 3f;
    public GameObject enemMissile;


    public GameObject enemContain;
    int enemCount;


    public float maxmoveInterval = 0.5f;
    public float minmoveInterval = 0.05f;
    float moveInterval;
    public float moveDist = 0.1f;
    float moveTimer;
    float hLimit = 2.5f;
    float moveDir = 1;


    public PlayerControl player;


    // Start is called before the first frame update
    void Start()
    {
        moveInterval = maxmoveInterval;
        shootTimer = shootInterval;
        enemCount = GetComponentsInChildren<EnemyControl>().Length;
    }

    // Update is called once per frame
    void Update()
    {

        /**Every few seconds, a randomy enemy shoots a missile towards the 
         * direction of the player. Failure to hit the player results in the 
         enemy missile self-destructing off of the screen.*/
        int currEnemCount = GetComponentsInChildren<EnemyControl>().Length;
        shootTimer -= Time.deltaTime;
        if (  currEnemCount > 0 && shootTimer <= 0)
        {
            shootTimer = shootInterval;
            GameObject missile = Instantiate(enemMissile);

            EnemyControl [] enemies = GetComponentsInChildren<EnemyControl> ();
            EnemyControl randEnemy = enemies[Random.Range(0, enemies.Length)];
            missile.transform.SetParent(transform);
            missile.transform.position = randEnemy.transform.position;
            missile.GetComponent<Rigidbody2D>().velocity = new Vector2(0, -shootSpd);
            Destroy(missile, 5);
        }


        /* Before being able to move, the enemies need to wait for the 
         * [moveTimer] to be at most 0. The enemies will move right or left, 
         * until the [rightest] or [leftest] enemy reaches the [hLimit] or 
         * -hLimit, respectively. After doing so, the [enemContain] will 
         * move downards by [moveDist], as well as the horizontal direction 
         * opposite to the border it previously reached. As the player destroys 
         * more enemies, the cool down time for enemy movement decreases-- 
         * resulting in the illusion of faster enemies.*/

        moveTimer -= Time.deltaTime;
        if(moveTimer <= 0)
        {
            float diff = 1 - (float)currEnemCount / enemCount;
            moveInterval =
                maxmoveInterval - (maxmoveInterval - minmoveInterval) * diff;
            moveTimer = moveInterval;
            enemContain.transform.position = new Vector2
                (enemContain.transform.position.x + moveDist * moveDir,
                enemContain.transform.position.y);
            if (moveDir > 0)
            {
                float rightest = 0;

                foreach (EnemyControl enem in
                    GetComponentsInChildren<EnemyControl>())
                {
                    if (enem.transform.position.x > rightest)
                    {
                        rightest = enem.transform.position.x;
                    }
                }

                if (rightest >= hLimit)
                {
                    moveDir *= -1;
                    enemContain.transform.position = new
                        Vector2(enemContain.transform.position.x,
                        enemContain.transform.position.y - moveDist);
                }
            }
            else
            {
                float leftest = 0;

                foreach (EnemyControl enem in
                    GetComponentsInChildren<EnemyControl>())
                {
                    if (enem.transform.position.x < leftest)
                    {
                        leftest = enem.transform.position.x;
                    }
                }

                if (leftest <= -hLimit)
                {
                    moveDir *= -1;
                    enemContain.transform.position = new
                        Vector2(enemContain.transform.position.x,
                        enemContain.transform.position.y - moveDist);
                }

            }
        }


        /**If either all of the enemies are destroyed or the player is 
         * destroyed, then the game starts over.*/

        if (currEnemCount == 0  || player == null)
        {
            SceneManager.LoadScene("Game");
        }
    }
}  
