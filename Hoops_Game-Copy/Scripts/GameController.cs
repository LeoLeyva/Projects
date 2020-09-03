using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameController : MonoBehaviour
{
    public Player p;
    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        /**If the player falls out of the court, then the scene will quickly be
         * restarted.*/
        if (p.transform.position.y < -5)
        {
            Invoke("restart", 3);
        }
    }


    void restart()
    {
        SceneManager.LoadScene("Hoops");
    }
}
