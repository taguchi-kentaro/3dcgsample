using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]

public class GBufferTest : MonoBehaviour {
	[SerializeField]
    Material testMat;

    private Camera _camera;

	void OnEnable() {
		_camera.depthTextureMode |= DepthTextureMode.Depth;
	}

	void OnDisable() {
	}

	void Reset() {
		_camera = GetComponent<Camera>();
	}

	// Use this for initialization
	void Start () {
	
	}

	void Awake() {
		_camera = GetComponent<Camera>();
	}

	void OnPreCull() {
	}

	[ImageEffectOpaque]
	void OnRenderImage( RenderTexture source, RenderTexture destination) {
		Graphics.Blit(source, destination, testMat);
	}
}
