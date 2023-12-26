



local PlayerCamera = {
	camera = nil
}

function PlayerCamera:Init()
	self.camera = workspace.CurrentCamera
	self.camera.CameraType = Enum.CameraType.Scriptable
	self.camera:GetPropertyChangedSignal("CameraType"):Wait()
	self.camera.CameraType = Enum.CameraType.Scriptable
end

return PlayerCamera