// A class for rectangles.
// Allows for rect-rect and rect-point collisions
abstract class Rect {
    abstract float left();
    abstract float right();
    abstract float top();
    abstract float bottom();

    boolean touching(float x, float y) {
        return x >= left() && x <= right() && y >= top()  && y <= bottom();
    }

    boolean touchingRect(Rect rect) {
        return !(
            left() > rect.right()  || right()  < rect.left() ||
            top()  > rect.bottom() || bottom() < rect.top()
        );
    }
}