
function CheckCollision(rect1, rect2)
  return rect1.x < rect2.x + rect2.w and
         rect2.x < rect1.x + rect1.w and
         rect1.y < rect2.y + rect2.h and
         rect2.y < rect1.y + rect1.h
end

function createRect(element, img)
  return {
    x = element.x,
    y = element.y,
    w = img:getWidth(),
    h = img:getHeight()
  }
end

